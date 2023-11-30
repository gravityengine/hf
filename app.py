from flask import Flask, request, render_template
import subprocess

app = Flask(__name__)

@app.route('/', methods=['GET'])
def index():
    command = request.args.get('command', '')
    output = ''
    if command:  # 如果有命令，则执行
        output = subprocess.getoutput(command)
    return render_template('index.html', output=output)

if __name__ == '__main__':
    app.run(debug=True)
