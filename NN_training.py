import cv2
import numpy as np
import os
import h5py
import keras
from keras.models import Sequential
from keras.layers import Dense
from keras.optimizers import RMSprop,SGD
from sklearn.neural_network import MLPClassifier

'''This function takes an integer and path and resize the image into integer x integer sized image and stores it in the same path'''
def resizeData(kk,path):
    for i in range(1,27):
        frame = cv2.imread(path+'red'+str(i)+'.jpg')
        crop_red = frame[250:250+kk,280:280+kk]
        #crop_red = cv2.resize(crop_red, (kk,kk), interpolation = cv2.INTER_AREA)
        cv2.imwrite(path+'red'+str(i)+'.jpg',crop_red)
    for i in range(27,51):
        frame = cv2.imread(path+'blue'+str(i)+'.jpg')
        crop_blue = frame[250:250+kk,280:280+kk]
        #crop_blue = cv2.resize(crop_blue, (kk,kk), interpolation = cv2.INTER_AREA)
        cv2.imwrite(path+'blue'+str(i-26)+'.jpg',crop_blue)
    for i in range(0,27):
        frame = cv2.imread(path+'green'+str(i)+'.jpg')
        crop_green = frame[250:250+kk,280:280+kk]
        #crop_green = cv2.resize(crop_green, (kk,kk), interpolation = cv2.INTER_AREA)
        cv2.imwrite(path+'green'+str(i+1)+'.jpg',crop_green)
    return

path = '../mnm_data/'
print("The path of dataset is: ",path)

kk=28
'''Use below line to resize the images if needed'''
#resizeData(kk)
y_blue = [0 for i in range(0,50)] #Creates a list for labels for blue
y_green = [1 for i in range(0,50)]#Creates a list for labels for green
y_red = [2 for i in range(0,50)]#Creates a list for labels for red
y = y_blue + y_green + y_red #Creates a list of labels for input images

print("Total labels: ",len(y))
##Split the data into training set and testing set
blue_train = int(len(y_blue)*0.80)
green_train = int(len(y_green)*0.80)
red_train = int(len(y_red)*0.80)
blue_test = len(y_blue) - blue_train
green_test = len(y_green) - green_train
red_test = len(y_red) - red_train
y_train = y[0:blue_train] + y[len(y_blue):len(y_blue)+green_train] + y[len(y_blue)+len(y_green):len(y_blue)+len(y_green)+red_train]
y_train = keras.utils.to_categorical(np.array(y_train), 3) #Convert the input labels into one-hot encoding. Training data
print("The number of train labels: ",len(y_train))

y_test = y[blue_train:len(y_blue)] + y[len(y_blue)+green_train:len(y_blue)+len(y_green)] + y[len(y_blue)+len(y_green)+red_train:len(y)]
y_test = keras.utils.to_categorical(np.array(y_test), 3) # Testing Data
print("The number of test labels: ",len(y_test))

image_paths = [os.path.join(path, f) for f in os.listdir(path)] #Read all the input image paths

images = []
for image_path in image_paths:  #Read all the images.
    image_pil = cv2.imread(image_path,0)
#image_pil = cv2.resize(image_pil, (4,4), interpolation = cv2.INTER_AREA) ##Use if resizing is needed while reading the images
    images.append(image_pil)  

print("The number of total images",len(images))
#Split the images data into training set and testing set
X_train = images[0:blue_train] + images[len(y_blue):len(y_blue)+green_train] + images[len(y_blue)+len(y_green):len(y_blue)+len(y_green)+red_train]
X_train = np.array(X_train)
X_train = X_train.reshape(len(X_train), kk*kk) #Vectorise the train image data in one array
X_train = X_train.astype('float32')
X_train /= 255  #Normalize the image data
print("The number of training images",X_train.shape[0])
X_test = images[blue_train:len(y_blue)] + images[len(y_blue)+green_train:len(y_blue)+len(y_green)] + images[len(y_blue)+len(y_green)+red_train:len(y)]
X_test = np.array(X_test)
X_test = X_test.reshape(len(X_test), kk*kk) #Vectorise the test image data in one array
X_test = X_test.astype('float32')
X_test /= 255  #Normalize the test data
print("The number of test images",X_test.shape[0])

#Set up the model for training the neural network in Keras
model = Sequential([Dense(100, activation='relu',use_bias=False,input_shape=(kk*kk,)),Dense(3,activation='softmax',use_bias=False)]) # Set up the number of nodes and parameters for each layer
model.summary()
sgd = SGD(lr=0.01, decay=1e-4, momentum=0.9, nesterov=True) # Define the parameters for optimizer
model.compile(loss='categorical_crossentropy',optimizer=sgd,metrics=['accuracy']) 

history = model.fit(X_train, y_train,epochs=1000,validation_data=(X_test, y_test),verbose=0) #Train the model on training data
score = model.evaluate(X_test, y_test, verbose=1) #Test the trained model on testing data

str1 = 'Keras Test loss '+str(kk)+' x'+str(kk)+'for dense layer '+str(100)+' : '+str(score[0])+'\n'
str2 = 'Keras Test accuracy '+str(kk)+'x'+str(kk)+'for dense layer '+str(100)+' : '+str(score[1]*100)+'\n'
print(str1)#Print the loss in the trained data
print(str2)#Print the accuracy of the trained data

#Save the model data in different files.
layerlist=['dense_1','dense_2']
if (score[1]*100)>60:
    model.save_weights('../model_data/NNmodel_weights.txt') # Save model weights to load the trained model in future
    for i in layerlist:
        layer = model.get_layer(i)
        weights = layer.get_weights()
        with open("../model_data/layer_wise_"+i+".txt", "w") as f: #Save the weights in different files for each layer to implement them in C
            for j in weights:
                for k in j:
                    f.write(str(k)+' , ')
            
    model_json = model.to_json()
    with open("../model_data/NN_model.json", "w") as json_file: #Save the trained model with exactly the same parameters to load model later
        json_file.write(model_json)

#Set up SKLearn model for comparison
clf2 = MLPClassifier(hidden_layer_sizes=(100, ), activation='relu', solver='adam',
                     batch_size='auto', learning_rate='constant', learning_rate_init=0.001,
                     max_iter=1000, random_state=None, tol=0.0001, verbose=False, nesterovs_momentum=True)
clf2.fit(X_train, y_train) # Train the SKLearn Model
accuracy = clf2.score(X_test, y_test) #Test the SKLearn model
print("Accuracy of test data in sklearn(NN)"+kk+"x"+kk+": ",accuracy*100) # Print Accuracy of the trained SKLearn model

if (accuracy*100)>75:
    with open('../model_data/sklearn_model_weights.txt','w') as f: #Save the weights of SKLearn model in a text file
        for i in clf2.coefs_:
            for j in i:
                f.write(str(j))
