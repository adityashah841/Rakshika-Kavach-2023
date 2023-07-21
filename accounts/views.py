from multiprocessing import AuthenticationError
from django.urls import reverse
from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.permissions import IsAuthenticated
from .models import DummyAadharInfo
from rest_framework_simplejwt.tokens import RefreshToken
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.response import Response

from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema

from .serializers import (AadharInfoSerializer, PhoneVerificationSerializer)

#phone verification
from . import verifyPhone

User = get_user_model()

class SignUp(generics.GenericAPIView):
    serializer_class = AadharInfoSerializer

    def post(self,request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            try: 
                user = DummyAadharInfo.objects.get(uid = serializer.data['aadhar_number'])
            except DummyAadharInfo.DoesNotExist:
                content = {'detail': 'Aadhar Number Invalid'}
                return JsonResponse(content, status = status.HTTP_404_NOT_FOUND) 
            
            User.objects.get_or_create(
                email = user.email,
                username = user.first_name + user.last_name,
                firstname = user.first_name,
                lastname = user.last_name,
                aadhar_number = user.uid,
                phone_number = user.phone,
                DOB = user.dob
            )

            number = '+91' + str(user.phone)
            try:
                verifyPhone.send(number)
            except:
                return JsonResponse({'error':"Activation Link has expired"}, status=status.HTTP_404_NOT_FOUND)
            content = {'detail': 'OTP sent'}
            return JsonResponse(content, status = status.HTTP_200_OK) 
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST) 



class VerifyPhoneView(generics.GenericAPIView):
    serializer_class = PhoneVerificationSerializer
    
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            if User.objects.filter(aadhar_number=serializer.data['aadhar_number']).exists():
                user = User.objects.get(aadhar_number=serializer.data['aadhar_number'])
                code = serializer.data['code']
                number = '+91' + str(user.phone_number)
                if verifyPhone.check(number, code):
                    user.is_active = True
                    user.save()
                    return JsonResponse({'status': 'Phone Successfully Verified'}, status=status.HTTP_200_OK)
        return JsonResponse({'error':"Code Expired"}, status=status.HTTP_400_BAD_REQUEST)
