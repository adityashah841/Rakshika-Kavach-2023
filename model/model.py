import cv2
import numpy as np
import dlib
import sys
import os
import imageio
from mtcnn.mtcnn import MTCNN

# This takes around 320 ms per frame
def extract_faces(video_filename, evidence_id):
    # if os.path.exists("media/faces") == False:
    #     print("Creating faces directory")
    #     os.mkdir("media/faces")
    # else:
    #     print("Faces directory already exists")

    # Load the video
    # video_capture = cv2.VideoCapture(video_filename)
    video_capture = imageio.get_reader(video_filename, 'ffmpeg')

    # Initialize the dlib face detector
    # detector = dlib.get_frontal_face_detector()
    # detector = dlib.cnn_face_detection_model_v1('mmod_human_face_detector.dat')
    detector = MTCNN()

    # Initialize the dlib face recognition model
    
    facenet = dlib.face_recognition_model_v1('model/dlib_face_recognition_resnet_model_v1.dat')

    # Initialize the dlib shape predictor
    predictor = dlib.shape_predictor('model/shape_predictor_68_face_landmarks.dat')

    frame_number = 0

    # Set a threshold for considering two faces to be the same
    threshold = 0.7

    # Create an empty list to store the embeddings of the saved faces
    saved_embeddings = []

    # Save the face images to return
    face_images = []

    for frame in video_capture:
        print(f"Processing frame {frame_number}")
        # Grab a single frame of video
        # ret, frame = video_capture.read()
        frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        # # Quit when the input video file ends
        # if not ret:
        #     break

        # # Resize the frame for better performance
        # small_frame = cv2.resize(frame, (0, 0), fx=1.5, fy=1.5)

        # Convert the image from BGR color (which OpenCV uses) to grayscale (which dlib uses)
        # gray_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)

        # Find all the faces in the current frame of video
        face_locations = detector.detect_faces(frame)
        # face_locations = detector(gray_frame, 1)

        # Loop through each face in this frame of video
        for i, face_location in enumerate(face_locations):
            # Get the coordinates of the face location
            # left = face_location.left()
            # top = face_location.top()
            # right = face_location.right()
            # bottom = face_location.bottom()
            # # Get the coordinates of the face location
            # rect = face_location.rect
            # left = rect.left()
            # top = rect.top()
            # right = rect.right()
            # bottom = rect.bottom()
            # Get the coordinates of the face location
            x, y, width, height = face_location['box']
            left = x
            top = y
            right = x + width
            bottom = y + height

            # Make sure the coordinates are within the bounds of the image
            left = max(0, left)
            top = max(0, top)
            right = min(frame.shape[1], right)
            bottom = min(frame.shape[0], bottom)

            # Extract the face from the image
            face_image = frame[top:bottom, left:right]

            # Calculate the face embedding
            shape = predictor(frame, dlib.rectangle(left, top, right, bottom))
            # shape = predictor(frame, rect)
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
                face_image_name = f"{evidence_id}_face_{frame_number}_{i}.jpg"
                flag = cv2.imwrite(os.path.join('media/faces' , f'face_{frame_number}_{i}.jpg'), face_image)
                print(flag)
                face_images.append((face_image_name, face_image))
                saved_embeddings.append(embedding)

        # Increment frame number
        frame_number += 1

    # # Release handle to the webcam
    # video_capture.release()
    return face_images

# filename = sys.argv[1]
# extract_faces(filename)
# print(os.path.split("xcvb.jpg"))

result = extract_faces('test_face_recog_10fps.mp4',1)
print(result)