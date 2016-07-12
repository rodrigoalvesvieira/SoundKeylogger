#!/usr/local/bin/python2
from sys import argv
import numpy as np
from pyAudioAnalysis import audioTrainTest as aT
from pyAudioAnalysis import audioTrainTest as aT

script, filename = argv

isSignificant = 0.3 #try different values.

#Result, P, classNames = aT.fileClassification(filename, "svmModel", "svm")
Result, P, classNames= aT.fileClassification(filename, "svmDTMF","svm")
winner = np.argmax(P)

if P[winner] > isSignificant :
  print(" A categoria eh: " + classNames[winner] + ", com probabilidade: " + str(P[winner]))
else :
  print("Impossivel classificar som: " + str(P))
