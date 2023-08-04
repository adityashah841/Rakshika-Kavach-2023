import cv2
import numpy as np
import dlib
import imageio
from mtcnn.mtcnn import MTCNN
import cloudinary.uploader
from decouple import config
from secrets import token_hex

cloudinary.config(
    cloud_name = config('CLOUDINARY_CLOUD_NAME'),
    api_key=config('CLOUDINARY_API_KEY'),
    api_secret=config('CLOUDINARY_API_SECRET'),
)
# This takes around 320 ms per frame
def extract_faces(video_filename, evidence_id):
    video_capture = imageio.get_reader(video_filename, 'ffmpeg')    
    print(video_capture)

    # Initialize the dlib face detector
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
        frame = cv2.cvtColor(frame, cv2.COLOR_RGB2BGR)

        # Find all the faces in the current frame of video
        face_locations = detector.detect_faces(frame)
        # face_locations = detector(gray_frame, 1)

        # Loop through each face in this frame of video
        for i, face_location in enumerate(face_locations):            
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
                face_image_name = f"{evidence_id}_face_{frame_number}_{token_hex(10)}.jpg"
                
                retval, buffer = cv2.imencode('.jpg', face_image)
                result = cloudinary.uploader.upload(
                    buffer.tobytes(), 
                    folder = 'media/images/suspects/faces', 
                    public_id = face_image_name
                    )
                cloud_url = result.get("url")
                face_images.append(cloud_url)
                saved_embeddings.append(embedding)

        # Increment frame number
        frame_number += 1

    # # Release handle to the webcam
    print(face_images)
    return face_images
