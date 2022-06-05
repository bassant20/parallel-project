# Importing flask module in the project is mandatory
# An object of Flask class is our WSGI application.
import threading
import time
from queue import Queue

from flask import Flask, request

totalU1I=0
totalU2I=0
amoubtI=0
# Flask constructor takes the name of
# current module (__name__) as argument.
app = Flask(__name__)

@app.route('/User2', methods=['GET', 'POST'])
def hello_world():
    totalU1I= request.args.get('input1')
    totalU2I = request.args.get('input2')
    amountI = request.args.get('input3')
    total=0
    lock = threading.Lock()
    def transfer(totalU2I, amountI):
        lock.acquire()
        global total
        totalU2I = int(totalU2I)
        totalU2I += int(amountI)
        # total += amountI
        total = totalU2I
        lock.release()
        print(amountI)
        print(totalU2I)
        return totalU2I

    # def join(self):
    #     Thread.join(self)
    #     return self._return
    print("first T"+totalU2I)
    print("first A"+amountI)
    que = Queue()
    th=threading.Thread(target=lambda:  que.put(transfer(totalU2I,amountI)))
    th.start()
    t=th.join()

    q=que.get()
    print(q)
    # time.sleep(5)
    #threading.active_count()
    #threading.current_thread().name
    return str(q)


@app.route('/User1', methods=['GET', 'POST'])
def hello():
    totalU1I= request.args.get('input1')
    totalU2I = request.args.get('input2')
    amountI = request.args.get('input3')
    total=0
    lock = threading.Lock()
    def transfer(totalU1I, amountI):
        lock.acquire()
        global total
        totalU1I = int(totalU1I)
        totalU1I -= int(amountI)
        # total += amountI
        total = totalU1I
        lock.release()
        print(amountI)
        print(totalU1I)
        return totalU1I

    print("first T" + totalU1I)
    print("first A" + amountI)
    que = Queue()
    th = threading.Thread(target=lambda: que.put(transfer(totalU1I, amountI)))
    th.start()
    t = th.join()

    q = que.get()
    print(q)
    # time.sleep(5)
    # threading.active_count()
    # threading.current_thread().name
    return str(q)


# main driver function
if __name__ == '__main__':
    # run() method of Flask class runs the application
    # on the local development server.
    app.run()
