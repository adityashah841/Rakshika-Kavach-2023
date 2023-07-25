from rest_framework import serializers
from django.contrib.auth import get_user_model
from rest_framework_simplejwt.tokens import RefreshToken, TokenError
from django.contrib import auth
from rest_framework.exceptions import AuthenticationFailed

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
            'refresh': str(tokens),
            'access': str(tokens.access_token)
        }