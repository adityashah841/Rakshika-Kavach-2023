from django.db import models
from accounts.models import User
from cloudinary_storage.storage import RawMediaCloudinaryStorage
# from cloudinary_storage.validators import validate_video

from django.conf import settings
import os

def get_video_upload_to(instance, filename):
    return f'videos/{instance.user.aadhar_number}/{filename}'

def get_audio_upload_to(instance, filename):
    return f'audios/{instance.user.aadhar_number}/{filename}'

# Create your models here.
class Evidence(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null = True, blank=True) # User name and parent's names are also required for filing a complaint
    timestamp = models.DateTimeField(auto_now_add=True)
    location = models.CharField(max_length=100) # Where the assault happened
    source = models.CharField(max_length=100) # The starting point of the girl's journey
    destination = models.CharField(max_length=100) # The planned destination
    planned_route = models.JSONField() # The route returned by the Maps API on frontend to the girl, which the girl was following
    # planned_route = models.CharField(max_length=100),
    isolated_zone_flag = models.BooleanField() # Whether the assault happened in an isolated zone
    authority_contacted = models.BooleanField() # Whether the authorities were contacted
    crime_type = models.CharField(max_length=100, default="Unknown") # The type of crime that happened
    action_taken = models.BooleanField() # Whether action was taken by the authorities
    action = models.CharField(max_length=100) # What action was taken by the authorities 
    action_taken_by = models.CharField(max_length=100) # Who took the action
    action_taken_timestamp = models.DateTimeField() # When the action was taken
    video = models.FileField(upload_to=get_video_upload_to, storage=RawMediaCloudinaryStorage())
    audio = models.FileField(upload_to=get_audio_upload_to, storage=RawMediaCloudinaryStorage())
    # action_taken = models.CharField(max_length=100)
    # action_taken_by = models.CharField(max_length=100)
    # action_taken_timestamp = models.DateTimeField(auto_now_add=True)
    # action_location = models.CharField(max_length=100)
    # video = models.URLField()
    # audio = models.URLField()

    def __str__ (self):
        return str(self.user.username) + '-' + str(self.id)

def get_image_upload_to(instance, filename):
        # Get the evidence_id from the instance
    evidence_id = instance.evidence.first().id
    # Return the desired upload path
    return f'suspects/{evidence_id}/{filename}'  

class Suspect(models.Model):
    # Note: This model DOES NOT store unique suspects, rather it records unique faces found.
    name = models.CharField(max_length=100, default='Unknown')
    image = models.URLField()
    evidence = models.ManyToManyField(Evidence, through='EvidenceSuspect')

class EvidenceSuspect(models.Model):
    evidence = models.ForeignKey(Evidence, on_delete=models.CASCADE)
    suspect = models.ForeignKey(Suspect, on_delete=models.CASCADE)

    class Meta:
        unique_together = ('evidence', 'suspect')