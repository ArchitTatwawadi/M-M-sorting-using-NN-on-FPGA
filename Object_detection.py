#Color based object detection and creating database of detected colors

import numpy as np
import cv2
import serial
import struct
import time

#Open port for video 
cap = cv2.VideoCapture(0)

#open port for UART communication
ser = serial.Serial('/dev/ttyAMA0', 115200, timeout=1)   
ser.open()



while(True):
	#read the frame
    _, frame = cap.read()
    
	# if signal is received from NEXYS4 FPGA then detect the object and send image to FPGA
    if(len(ser.read(1))>0):

		#Convert image into HSV for color masking
        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
		
		#Define the upper and lowwer range of colors for masking
        lower_red=np.array([136,80,70],np.uint8)
        upper_red=np.array([180,255,255],np.uint8)

        lower_blue=np.array([99,115,150],np.uint8)
        upper_blue=np.array([110,255,255],np.uint8)

        lower_green=np.array([30,60,100],np.uint8)
        upper_green=np.array([90,255,255],np.uint8)

        kernal=np.ones((5,5),"uint8")

		#Mask the RGB color
        red=cv2.inRange(hsv,lower_red,upper_red)
        blue=cv2.inRange(hsv,lower_blue,upper_blue)
        green=cv2.inRange(hsv,lower_green,upper_green)
        
		# Reduce noise in image by applaying dilation
        red=cv2.dilate(red,kernal)
        res=cv2.bitwise_and(frame,frame,mask=red)

        blue=cv2.dilate(blue,kernal)
        res1=cv2.bitwise_and(frame,frame,mask=blue)

        green=cv2.dilate(green,kernal)
        res2=cv2.bitwise_and(frame,frame,mask=green)

		##Findout the color area in image
		# crop (28x28) the middle portion of color 
		
		#For red color
        (_,contours,hierarchy)=cv2.findContours(red,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)

        for pic,contour in enumerate(contours):
            area=cv2.contourArea(contour)
            if(area>300):
                x,y,w,h=cv2.boundingRect(contour)
                frame=cv2.rectangle(frame,(x,y),(x+w,y+h),(0,0,255),2)
                roi_color = frame[y:y+h, x:x+w]
                h=int(h/2)
                w=int(w/2)
                if int(h/2)>28 & int(w/2)>28:
                    r = frame[y+int(h/2):y+int(h/2)+28, x+int(w/2):x+int(w/2)+28]
                else:
                    r = frame[y+int(h/2):y+h, x+int(w/2):x+w]
                    r = cv2.resize(r,(28,28),interpolation = cv2.INTER_AREA)
                if cv2.waitKey(1) & 0xFF == ord('a'):
                    red_name='red'+str(red_c)+'.jpg' 
                    cv2.imwrite(red_name,r)
                    red_c=red_c+1
                    
                
		#For blue color
        (_,contours,hierarchy)=cv2.findContours(blue,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)

        for pic,contour in enumerate(contours):
            area=cv2.contourArea(contour)
            if(area>300):
                x,y,w,h=cv2.boundingRect(contour)
                frame=cv2.rectangle(frame,(x,y),(x+w,y+h),(255,0,0),2)
                roi_color = frame[y:y+h, x:x+w]
                
                h=int(h/2)
                w=int(w/2)
                if int(h/2)>28 & int(w/2)>28:
                    r = frame[y+int(h/2):y+int(h/2)+28, x+int(w/2):x+int(w/2)+28]
                else:
                    r = frame[y+int(h/2):y+h, x+int(w/2):x+w]
                    r = cv2.resize(r,(28,28),interpolation = cv2.INTER_AREA)
                if cv2.waitKey(1) & 0xFF == ord('s'):
                    blue_name='blue'+str(blue_c)+'.jpg'
                    
                    cv2.imwrite(blue_name,r)
                    blue_c=blue_c+1

		#for green color
        (_,contours,hierarchy)=cv2.findContours(green,cv2.RETR_TREE,cv2.CHAIN_APPROX_SIMPLE)

        for pic,contour in enumerate(contours):
            area=cv2.contourArea(contour)
            if(area>300):
                x,y,w,h=cv2.boundingRect(contour)
                frame=cv2.rectangle(frame,(x,y),(x+w,y+h),(0,255,0),2)
                roi_color = frame[y:y+h, x:x+w]
                h=int(h/2)
                w=int(w/2)
                if int(h/2)>28 & int(w/2)>28:
                    r = frame[y+int(h/2):y+int(h/2)+28, x+int(w/2):x+int(w/2)+28]
                else:
                    r = frame[y+int(h/2):y+h, x+int(w/2):x+w]
                    r = cv2.resize(r,(28,28),interpolation = cv2.INTER_AREA)
                if cv2.waitKey(1) & 0xFF == ord('d'):
                    green_name='green'+str(green_c)+'.jpg'
                    
                    cv2.imwrite(green_name,r)
                    green_c=green_c+1
      
		#convert croped image into grayscale image
        frame1 = cv2.cvtColor(r, cv2.COLOR_BGR2GRAY)
		# Convert 28x28 (2D Array) image into 1D array for sending to FPGA
        frame2=frame1.reshape(1,784)
		#send image through UART 
        for i in frame2[0]:   
            ser.write(struct.pack('>B', i ))
        print('image done')
   
	# If 'q' key is pressed then exit
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
		
#close the video capturing port	
cap.release()
cv2.destroyAllWindows()
