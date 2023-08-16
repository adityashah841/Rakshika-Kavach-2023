from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
from django.contrib import auth
from rest_framework.exceptions import AuthenticationFailed
from .models import Address, EmergencyContact, StateEmergencyContact

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
  
class LoginSerializer(serializers.ModelSerializer):
    phone = serializers.DecimalField(max_digits = 12, decimal_places = 0)
    password = serializers.CharField(max_length=68, min_length=3)
    tokens = serializers.CharField(max_length=68, min_length=8, read_only=True)

    class Meta:
        model=User
        fields = ['phone', 'password', 'tokens']

    def validate(self, attrs):

        phone = attrs.get('phone','')
        password = attrs.get('password', '')

        # filtered_user_by_phone = User.objects.filter(phone_number=phone)
        auth_user = auth.authenticate(phone_number=phone, password=password)

        if not auth_user:
            raise AuthenticationFailed("Invalid credentials, try again")
        if not auth_user.is_active:
            raise AuthenticationFailed("Phone not verified yet!!")

        tokens = RefreshToken.for_user(user=auth_user)

        return {
            'username': (auth_user.username),
            'gender': (auth_user.gender),
            'refresh': str(tokens),
            'access': str(tokens.access_token)
        }
    
class UserSerializer(serializers.ModelSerializer):
    aadhar_number = serializers.CharField(max_length=68, min_length=8, read_only=True)
    phone_number = serializers.IntegerField(read_only=True)
    DOB = serializers.CharField(max_length=10, min_length=8, read_only=True)

    class Meta:
        model = User
        fields = ['id','aadhar_number','phone_number','email','username', 'firstname', 'lastname','image','DOB','latitude', 'longitude']


class AddressSerializer(serializers.ModelSerializer):

    class Meta:
        model = Address
        fields = '__all__'


class EmergencyContactSerializer(serializers.ModelSerializer):

    class Meta:
        model = EmergencyContact
        fields = '__all__'