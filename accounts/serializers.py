from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken, TokenError

User = get_user_model()

class AadharInfoSerializer(serializers.Serializer):
    aadhar_number = serializers.CharField(max_length=12)

    class Meta:
        fields = ['aadhar_number']


class PhoneVerificationSerializer(serializers.Serializer):
    code = serializers.CharField(max_length=8)
    aadhar_number = serializers.CharField(max_length=12)

    class Meta:
        fields = ['aadhar_number','code']
    
    

class SetPasswordSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=30)
    password = serializers.CharField(
        min_length=6, max_length=68, write_only=True)
    
    class Meta:
        fields = ['username','password']
  
