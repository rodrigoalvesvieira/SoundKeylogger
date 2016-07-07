#Dependências

NUMPY 	sudo apt-get install python-numpy 
MATPLOTLIB 	sudo apt-get install python-matplotlib 
SCIPY 	sudo apt-get install python-scipy 
GSL  	sudo apt-get install libgsl0-dev 
MLPY
	wget http://sourceforge.net/projects/mlpy/files/mlpy%203.5.0/mlpy-3.5.0.tar.gz
	tar xvf mlpy-3.5.0.tar.gz
	cd mlpy-3.5.0
	sudo python setup.py install
SKLEARN
	sudo pip install scikit-learn==0.16.1
Scikits talkbox
	sudo pip install scikits.talkbox
Simplejson
	sudo easy_install simplejson

EyeD3D
	sudo pip install eyeD3D


#Executar
##Gerar classificadores
	python generate_classifier.py 

##Classificar arquivo
	python classify.py __FULL_FILE_NAME__