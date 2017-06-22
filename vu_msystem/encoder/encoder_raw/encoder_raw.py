#!/usr/bin/python

# helper class for vunit simulation of encoder_raw entity
# every test hat 5 states: reset, pair 1, pair 2, pair 3, pair 3 (repetition)
# in python generator will be 3 pairs defined

class EncodeRaw(object):
    def __init__(self):
        self.state = self.RESET

    # internal states
    (RESET, S00, S01, S11, S10) = range(5)

    def generator(self):
        """
        creates the list of inputs for simulation.
        One input is a list of 3 tupples [(a,b),(a,b),(a,b)]
        a and b are signals for inputs a and b
        :return: list 64 elsments, every element: list with 3 tupples
        """
        listStim = []
        runningNr = 0
        for i in range(64):
            subList = []
            #subList.append(runningNr)
            binstring = format(i,"06b")
            a = int(binstring[0])
            b = int(binstring[1])
            c = int(binstring[2])
            d = int(binstring[3])
            e = int(binstring[4])
            f = int(binstring[5])
            subList.append((a,b))
            subList.append((c,d))
            subList.append((e,f))
            listStim.append(subList)
            runningNr += 1
        return listStim

    def predictor(self, inputLIst):
        """
        form input list will be the list of tupples geberated,
        every tupple sgows two signals: up, down for every time tick
        Internal will be used a python implementation of quadrature encoder SM
        :param inputLIst: list of tupple from generator
        :return: list of tupples (up, down) for every time-tick
        """
        outputList = []
        self.state = self.RESET
        for item in inputLIst:
            if self.state == self.RESET:
                if item == (0, 0):
                    self.state = self.S00
                    outputList.append((0,0))
                elif item == (0, 1):
                    self.state = self.S01
                    outputList.append((0,1))
                elif item == (1, 0):
                    self.state = self.S10
                    outputList.append((1,0))
                elif item == (1, 1):
                    self.state = self.S11
                    outputList.append((0, 0))
                else:
                    raise AssertionError()

            elif self.state == self.S00:
                if item == (0, 0):
                    self.state = self.S00
                    outputList.append((0,0))
                elif item == (0, 1):
                    self.state = self.S01
                    outputList.append((0,1))
                elif item == (1, 0):
                    self.state = self.S10
                    outputList.append((1,0))
                elif item == (1, 1): #should be not in real life
                    self.state = self.S00
                    outputList.append((0, 0))
                else:
                    raise AssertionError()
            elif self.state == self.S01:
                if item == (0, 0):
                    self.state = self.S00
                    outputList.append((1,0))
                elif item == (0, 1):
                    self.state = self.S01
                    outputList.append((0,0))
                elif item == (1, 0):  # should be not in real life
                    self.state = self.S10
                    outputList.append((0, 0))
                elif item == (1, 1):
                    self.state = self.S11
                    outputList.append((0,1))
                else:
                    raise AssertionError()
            elif self.state == self.S11:
                if item == (0, 0):# should be not in real life
                    self.state = self.S00
                    outputList.append((0, 0))
                elif item == (0, 1):
                    self.state = self.S01
                    outputList.append((1, 0))
                elif item == (1, 1):
                    self.state = self.S11
                    outputList.append((0, 0))
                elif item == (1, 0):
                    self.state = self.S10
                    outputList.append((0, 1))
                else:
                    raise AssertionError()
            elif self.state == self.S10:
                if item == (0, 0):
                    self.state = self.S00
                    outputList.append((0, 1))
                elif item == (0, 1):# should be not in real life
                    self.state = self.S01
                    outputList.append((0, 0))
                elif item == (1, 1):
                    self.state = self.S11
                    outputList.append((1, 0))
                elif item == (1, 0):
                    self.state = self.S10
                    outputList.append((0, 0))
                else:
                    raise AssertionError()
        return outputList

    def stimLineBuilder(self, inputList, resultList):
        """
        from both inputs: from generator and from predictor
        will be a vector build to use in vunit vhdl tb
        :param inputList:
        :param resultList:
        :return:one line for one stimulus,
        line: vector for a, vector for b, vector for up and vector for down
        """
        vector_a = []
        vector_b = []
        vector_up = []
        vector_down = []
        for item in inputList:
            vector_a.append(item[1])#a
            vector_b.append(item[0])#b
        for item in resultList:
            vector_up.append(item[1])
            vector_down.append(item[0])
        str_a = ''.join(str(e) for e in vector_a)
        str_b = ''.join(str(e) for e in vector_b)
        str_up = ''.join(str(e) for e in vector_up)
        str_down = ''.join(str(e) for e in vector_down)
        outputString = str_a + ' ' + str_b + ' ' + str_up + ' ' + str_down
        return outputString

if __name__ == '__main__':
    encoderGenStim = EncodeRaw()
    stimList = encoderGenStim.generator()
    stimulus_file = open("encoder_raw_stim.txt", "w")
    stimulus_file.write("a b up down\n")
    for list in stimList:
        resultList = encoderGenStim.predictor(list)
        stimLine = encoderGenStim.stimLineBuilder(list, resultList)
        stimulus_file.write("%s\n" % stimLine)
        #print stimLine
    stimulus_file.close()
