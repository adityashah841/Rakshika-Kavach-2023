from django.db import models
from accounts.models import User
from cloudinary_storage.storage import RawMediaCloudinaryStorage

def get_video_upload_to(instance, filename):
    return f'efir_videos/{instance.user.aadhar_number}/{filename}'

def get_audio_upload_to(instance, filename):
    return f'efir_audios/{instance.user.aadhar_number}/{filename}'

STATUS = (
    ('Pending', 'Pending'),
    ('Approved', 'Approved'),
    ('Rejected', 'Rejected')
)

class EFir(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null = True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    crime_description = models.TextField()
    location = models.CharField(max_length=100)
    video = models.FileField(upload_to=get_video_upload_to, storage=RawMediaCloudinaryStorage(), blank=True)
    audio = models.FileField(upload_to=get_audio_upload_to, storage=RawMediaCloudinaryStorage(), blank=True)
    status = models.CharField(max_length=100, choices=STATUS, default='Pending')