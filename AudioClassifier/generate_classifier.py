from pyAudioAnalysis import audioTrainTest as aT

aT.featureAndTrain(["./categories/tecla_0","./categories/tecla_1","./categories/tecla_2","./categories/tecla_3","./categories/tecla_4","./categories/tecla_5","./categories/tecla_6","./categories/tecla_7","./categories/tecla_8","./categories/tecla_9"], 1.0, 1.0, aT.shortTermWindow, aT.shortTermStep, "svm", "svmDTMF", False)

aT.featureAndTrain(["./categories/tecla_0","./categories/tecla_1","./categories/tecla_2","./categories/tecla_3","./categories/tecla_4","./categories/tecla_5","./categories/tecla_6","./categories/tecla_7","./categories/tecla_8","./categories/tecla_9"], 1.0, 1.0, aT.shortTermWindow, aT.shortTermStep, "knn", "knnDTMF", False)
