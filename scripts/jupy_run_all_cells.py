import argparse
import json
import requests
import uuid
import websocket # pip install websocket-client

class JupyRunner():
    def __init__(self, ip, port, token, file_path, output):
        self.ip = ip
        self.port = port
        self.token = token
        self.base_url = 'http://' + ip + ':' + port
        self.file_path = file_path
        self.output = output
        self.headers = {
            'Authorization': 'token ' + token
        }
        self.responses = []

    def runAllCells(self):
        if not self.__validate():
            print('invalid args')
            return
        kernel_id = self.__runKernel()
        self.__writeOutputs()
        self.__deleteKernel(kernel_id)

    def __validate(self):
        url = self.base_url + '/api/contents/' + self.file_path
        response = requests.get(url, headers=self.headers)

        return (response.status_code == 200)

    def __sendCode(self, socket, msg_id, code):
        header = {
            'msg_type': 'execute_request',
            'msg_id': msg_id,
            'session': uuid.uuid1().hex
        }

        message = json.dumps({
            'header': header,
            'channel': 'shell',
            'parent_header': header,
            'metadata': {},
            'content': {
                'code': code,
                'silent': False
            }
        })

        socket.send(message)

    def __runKernel(self):
        url = self.base_url + '/api/kernels'
        response = requests.post(url, headers=self.headers)
        kernel = json.loads(response.text)
        kernel_id = kernel['id']

        url = self.base_url + '/api/contents/' + self.file_path
        response = requests.get(url, headers=self.headers)
        notebook = json.loads(response.text)

        session_id = uuid.uuid1().hex
        url = 'ws://' + self.ip + ':' + self.port + '/api/kernels/' + \
            kernel_id + '/channels?session_id=' + session_id
        socket = websocket.create_connection(url, header=self.headers)

        for cell in notebook['content']['cells']:
            if cell['cell_type'] == 'code':
                self.__sendCode(socket, cell['id'], cell['source'])

        self.__sendCode(socket, uuid.uuid1().hex,
                        'print("' + kernel_id + '", end="")')

        while True:
            response = json.loads(socket.recv())
            msg_type = response['msg_type']

            if msg_type == 'error':
                self.responses.append(response)
                socket.close()
                break

            if not (msg_type == 'stream' or msg_type == 'display_data'):
                continue

            output = response['content']

            if msg_type == 'stream' and output['text'] == kernel_id:
                socket.close()
                break

            self.responses.append(response)

        return kernel_id

    def __writeOutputs(self):
        with open(self.file_path) as f:
            notebook = json.load(f)

        for cell in notebook['cells']:
            outputs = []
            for res in self.responses:
                if cell['id'] == res['parent_header']['msg_id']:
                    if res['msg_type'] == 'stream':
                        output = {
                            'name': 'stdout',
                            'output_type': 'stream',
                            'text': res['content']['text']
                        }
                    elif res['msg_type'] == 'display_data':
                        output = {
                            'metadata': res['metadata'],
                            'output_type': 'display_data',
                            'data': res['content']['data']
                        }
                    elif res['msg_type'] == 'error':
                        output = {
                            'ename': res['content']['ename'],
                            'evalue': res['content']['evalue'],
                            'output_type': 'error',
                            'traceback': res['content']['traceback']
                        }
                    else:
                        output = {
                            'name': 'stdout',
                            'output_type': 'stream',
                            'text': 'unknown msg_type: ' + res['msg_type']
                        }
                    outputs.append(output)
                    cell['outputs'] = outputs

        # update notebook
        with open(self.output, 'w') as f:
            json.dump(notebook, f)

    def __deleteKernel(self, kernel_id):
        url = self.base_url + '/api/kernels/' + kernel_id
        response = requests.delete(url, headers=self.headers)

def main():
    parser = argparse.ArgumentParser()

    me_group = parser.add_mutually_exclusive_group(required=True)
    me_group.add_argument('--url', type=str)
    me_group.add_argument('--token', type=str)
    parser.add_argument('--ip', default='127.0.0.1', type=str)
    parser.add_argument('--port', default=8888, type=int)
    parser.add_argument('--output', type=str)

    parser.add_argument('file_path', type=str)
    args = parser.parse_args()

    if args.url == None:
        ip = args.ip
        port = str(args.port)
        token = args.token
    else:
        url = args.url.split('://')[1]
        url = url.split('/')[0]
        ip = url.split(':')[0]
        port = url.split(':')[1]
        token = args.url.split('?token=')[1]

    if args.output == None:
        output = args.file_path
    else:
        output = args.output

    runner = JupyRunner(ip, port, token, args.file_path, output)
    runner.runAllCells()

if __name__ == '__main__':
    main()

