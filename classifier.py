# encoding: utf-8
from sklearn.neighbors import NearestNeighbors, KNeighborsClassifier
from sklearn.metrics import confusion_matrix, accuracy_score
from sklearn import svm
from sklearn import tree
from scipy import spatial
from sys import argv
from collections import Counter
import argparse
import numpy  as np


class OCR:
	def __init__(self, trainningFile, testFile):
		self.trainningFile = trainningFile[:-4]
		self.testFile = testFile[:-4]

	
	def separateFiles(self, trainningFile, testFile):	
		with open(trainningFile, 'r') as file:
			labels = []
			characteristics = []
			data = np.loadtxt(file)
			for line in data:
				labels.append(line[len(data[0])-1])			
			for line in data:
				characteristics.append(line[:-1])	
			np.savetxt(self.trainningFile+'_labels.txt', labels)
			np.savetxt(self.trainningFile+'_characteristics.txt', characteristics)	
		with open(testFile, 'r') as file:
			labels = []
			characteristics = []						
			data = np.loadtxt(file)
			for line in data:
				labels.append(line[len(data[0])-1])			
			for line in data:
				characteristics.append(line[:-1])	
			np.savetxt(self.testFile+'_labels.txt', labels)
			np.savetxt(self.testFile+'_characteristics.txt', characteristics)
	
	# Extrai os dados do arquivo e retorna uma matriz
	def extract(self, fileName):
		with open(fileName) as file:
			data = np.loadtxt(file)
		return data

	def knn(self, trainning_characteristics, trainning_labels, test_characteristics, n_neighbors):
		neigh = KNeighborsClassifier(n_neighbors)
		neigh.fit(trainning_characteristics, trainning_labels)

		classified = neigh.predict(test_characteristics)
		prob = neigh.predict_proba(test_characteristics)
		
		return classified
	
	def svm(self, trainning_characteristics, trainning_labels, test_characteristics):
		clf = svm.SVC(gamma=0.0001, C=100)
		x = trainning_characteristics
		y = trainning_labels
		clf.fit(x, y)
		classified = clf.predict(test_characteristics)
		
		return classified

	def decision_tree(self, trainning_characteristics, trainning_labels, test_characteristics):
		x = trainning_characteristics
		y = trainning_labels
		clf = tree.DecisionTreeClassifier()
		clf = clf.fit(x, y)
		classified = clf.predict(test_characteristics)
		
		return classified

	def buildConfusionMatrix(self, classified, test_labels):	
		confusionMatrix = confusion_matrix(test_labels, classified)
		return confusionMatrix

	def voto_majoritario(self, classifiedKnn, classifiedSVM, classifiedDTree):
		classified = []
		zipped = zip(classifiedKnn, classifiedSVM, classifiedDTree)
		for i in zipped:
			classified.append(Counter(i).most_common(1)[0][0])

		return classified


if __name__ == '__main__':
	
	arg_parser = argparse.ArgumentParser()
	arg_parser.add_argument("trainning_file", help="arquivo de treinamento")
	arg_parser.add_argument("test_file", help="arquivo de teste")
	#arg_parser.add_argument("k1", type=int, help="numero k1")
	#arg_parser.add_argument("k2", type=int, help="numero k2")
	#arg_parser.add_argument("k3", type=int, help="numero k3")
	arg_parser = arg_parser.parse_args()

	ocr = OCR(arg_parser.trainning_file, arg_parser.test_file)

	ocr.separateFiles(arg_parser.trainning_file, arg_parser.test_file)

	trainningLabelsFile = arg_parser.trainning_file[:-4]+'_labels.txt'
	trainningCharacteristicsFile = arg_parser.trainning_file[:-4]+'_characteristics.txt'	

	trainning_labels = ocr.extract(trainningLabelsFile)
	trainning_characteristics = ocr.extract(trainningCharacteristicsFile)

	testLabelsFile = arg_parser.test_file[:-4]+'_labels.txt'
	testCharacteristicsFile = arg_parser.test_file[:-4]+'_characteristics.txt'

	test_labels = ocr.extract(testLabelsFile)
	test_characteristics = ocr.extract(testCharacteristicsFile)

	k1 = 1
	k2 = 3
	k3 = 5

	print "Classificador K-nn com K =", k1
	classifiedKNN = ocr.knn(trainning_characteristics, trainning_labels, test_characteristics, k1)
	accuracy = accuracy_score(test_labels, classifiedKNN)
	print "Precisão:",accuracy*100,"%"
	matrix = ocr.buildConfusionMatrix(classifiedKNN, test_labels)
	print ("matriz de confusão:")
	for i in range(0,26):
		for j in range(0,26):
			if matrix[i,j] < 100:
				if matrix[i,j] < 10:					
					aux = '00'
					aux = aux + (str(matrix[i,j]))
					print aux,				
				else:
					aux = '0'
					aux = aux + (str(matrix[i,j]))
					print aux,				
			else:
				print matrix[i,j],
		print

	print "Fim do K-nn com K =",k1
	print "\n"

	print "Classificador K-nn com K =", k2
	classifiedKNN = ocr.knn(trainning_characteristics, trainning_labels, test_characteristics, k2)
	accuracy = accuracy_score(test_labels, classifiedKNN)
	print "Precisão:", accuracy*100,"%"
	matrix = ocr.buildConfusionMatrix(classifiedKNN, test_labels)
	print ("matriz de confusão:")
	for i in range(0,26):
		for j in range(0,26):
			if matrix[i,j] < 100:
				if matrix[i,j] < 10:					
					aux = '00'
					aux = aux + (str(matrix[i,j]))
					print aux,				
				else:
					aux = '0'
					aux = aux + (str(matrix[i,j]))
					print aux,				
			else:
				print matrix[i,j],
		print
	print "Fim do K-nn com K =",k2
	print "\n"
	

	print "Classificador K-nn com K =", k3
	classifiedKNN = ocr.knn(trainning_characteristics, trainning_labels, test_characteristics, k3)
	accuracy = accuracy_score(test_labels, classifiedKNN)
	print "Precisão:",accuracy*100,"%"
	matrix = ocr.buildConfusionMatrix(classifiedKNN, test_labels)
	print ("matriz de confusão:")
	for i in range(0,26):
		for j in range(0,26):
			if matrix[i,j] < 100:
				if matrix[i,j] < 10:					
					aux = '00'
					aux = aux + (str(matrix[i,j]))
					print aux,				
				else:
					aux = '0'
					aux = aux + (str(matrix[i,j]))
					print aux,				
			else:
				print matrix[i,j],
		print
	print "Fim do K-nn com K =",k3
	print "\n"



	print("Classificador SVM")	
	classifiedSVM = ocr.svm(trainning_characteristics, trainning_labels, test_characteristics)
	accuracy = accuracy_score(test_labels, classifiedSVM)
	print "Precisão:",accuracy*100,"%"
	matrix = ocr.buildConfusionMatrix(classifiedSVM, test_labels)
	print ("matriz de confusão:")
	for i in range(0,26):
		for j in range(0,26):
			if matrix[i,j] < 100:
				if matrix[i,j] < 10:					
					aux = '00'
					aux = aux + (str(matrix[i,j]))
					print aux,				
				else:
					aux = '0'
					aux = aux + (str(matrix[i,j]))
					print aux,				
			else:
				print matrix[i,j],
		print
	print "FIM do SVM"
	print "\n"



	print("Árvore de decisão")	
	classifiedDTree = ocr.decision_tree(trainning_characteristics, trainning_labels, test_characteristics)
	accuracy = accuracy_score(test_labels, classifiedDTree)
	print "Precisão:",accuracy*100,"%"
	matrix = ocr.buildConfusionMatrix(classifiedDTree, test_labels)
	print ("matriz de confusão:")
	for i in range(0,26):
		for j in range(0,26):
			if matrix[i,j] < 100:
				if matrix[i,j] < 10:					
					aux = '00'
					aux = aux + (str(matrix[i,j]))
					print aux,				
				else:
					aux = '0'
					aux = aux + (str(matrix[i,j]))
					print aux,				
			else:
				print matrix[i,j],
		print
	print "FIM da Árvore de decisão"
	print "\n"

	print "Voto Majoritário"
	classified = ocr.voto_majoritario(classifiedKNN, classifiedSVM, classifiedDTree)
	accuracy = accuracy_score(test_labels, classified)
	print "Precisão:", accuracy*100,"%"
	matrix = ocr.buildConfusionMatrix(classified, test_labels)
	print("matriz de confusão:")
	for i in range(0,26):
		for j in range(0,26):
			if matrix[i,j] < 100:
				if matrix[i,j] < 10:					
					aux = '00'
					aux = aux + (str(matrix[i,j]))
					print aux,				
				else:
					aux = '0'
					aux = aux + (str(matrix[i,j]))
					print aux,				
			else:
				print matrix[i,j],
		print

	print "fim da execução!"