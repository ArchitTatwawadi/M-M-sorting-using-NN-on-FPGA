import cv2

cam = cv2.VideoCapture(1)

cv2.namedWindow("test")

img_counter = 0

while True:
    ret, frame = cam.read()
    cv2.imshow("test", frame)
    if not ret:
        break
    k = cv2.waitKey(1)

    if k%256 == 27:
        # ESC pressed
        print("Escape hit, closing...")
        break
    elif k%256 == 32:
        # SPACE pressed
        img_name = "blue"+str(img_counter)+".jpg"
        cv2.imwrite(img_name, frame)
        print(img_name+" written!")
        img_counter += 1

cam.release()

cv2.destroyAllWindows()
