import cv2
import numpy as np
import dlib
import sys
import os

def extract_faces(video_filename):
    if os.path.exists("faces") == False:
        os.mkdir("faces")

    # Load the video
    video_capture = cv2.VideoCapture(video_filename)

    # Initialize the dlib face detector
    # detector = dlib.get_frontal_face_detector()
    detector = dlib.cnn_face_detection_model_v1('mmod_human_face_detector.dat')

    # Initialize the dlib face recognition model
    facenet = dlib.face_recognition_model_v1('dlib_face_recognition_resnet_model_v1.dat')

    # Initialize the dlib shape predictor
    predictor = dlib.shape_predictor('shape_predictor_68_face_landmarks.dat')

    frame_number = 0

    # Set a threshold for considering two faces to be the same
    threshold = 0.625

    # Create an empty list to store the embeddings of the saved faces
    saved_embeddings = []

    # Save the face images to return
    face_images = []

    while True:
        print(f"Processing frame {frame_number}")
        # Grab a single frame of video
        ret, frame = video_capture.read()

        # Quit when the input video file ends
        if not ret:
            break

        # Convert the image from BGR color (which OpenCV uses) to grayscale (which dlib uses)
        gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        # Find all the faces in the current frame of video
        face_locations = detector(gray_frame, 1)

        # Loop through each face in this frame of video
        for i, face_location in enumerate(face_locations):
            # Get the coordinates of the face location
            # left = face_location.left()
            # top = face_location.top()
            # right = face_location.right()
            # bottom = face_location.bottom()
            # Get the coordinates of the face location
            rect = face_location.rect
            left = rect.left()
            top = rect.top()
            right = rect.right()
            bottom = rect.bottom()


            # Make sure the coordinates are within the bounds of the image
            left = max(0, left)
            top = max(0, top)
            right = min(frame.shape[1], right)
            bottom = min(frame.shape[0], bottom)

            # Extract the face from the image
            face_image = frame[top:bottom, left:right]

            # Calculate the face embedding
            shape = predictor(gray_frame, face_location.rect)
            embedding = np.array(facenet.compute_face_descriptor(frame, shape))

            # Check if this face is similar to any of the saved faces
            is_new_face = True
            distance = 0
            for saved_embedding in saved_embeddings:
                distance = np.linalg.norm(embedding - saved_embedding)
                if distance < threshold:
                    is_new_face = False
                    break

            # If this is a new face, save it and add its embedding to the list of saved embeddings
            if is_new_face:
                print(distance)
                print(f"face_{frame_number}_{i}")
                # cv2.imshow(f"face_{frame_number}_{i}", face_image)
                # flag = cv2.imwrite(f"faces\\face_{frame_number}_{i}.jpg", face_image)
                # print(flag)
                face_images.append(face_image)
                saved_embeddings.append(embedding)

        # Increment frame number
        frame_number += 1

    # Release handle to the webcam
    video_capture.release()
    return face_images

# filename = sys.argv[1]
# extract_faces(filename)