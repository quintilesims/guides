import sys
import flask
import signal

app = flask.Flask(__name__)
entries = []

@app.route('/', methods=['GET'])
def main_page():
    return flask.render_template('main.html', entries=entries)

@app.route('/entries', methods=['POST'])
def create_entry():
    entries.append(flask.request.form['entry'])
    return flask.redirect(flask.url_for('main_page'))

@app.route('/clear', methods=['POST'])
def clear_entries():
    del entries[:]
    return flask.redirect(flask.url_for('main_page'))

def signal_handler(signal, frame):
        sys.exit(0)

if __name__ == "__main__":
  signal.signal(signal.SIGINT, signal_handler)
  app.run(host='0.0.0.0', port=80, threaded=True)
