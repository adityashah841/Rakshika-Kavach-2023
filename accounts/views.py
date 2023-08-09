from multiprocessing import AuthenticationError
from django.urls import reverse
from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.permissions import IsAuthenticated
from .models import DummyAadharInfo, Address, EmergencyContact
from rest_framework_simplejwt.tokens import RefreshToken
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.response import Response

from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema

from .serializers import (AadharInfoSerializer, PhoneVerificationSerializer, 
                          SetPasswordSerializer, LoginSerializer, UserSerializer, 
                          AddressSerializer, EmergencyContactSerializer)

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
            try:
                user = User.objects.get(aadhar_number = user.uid)
            except User.DoesNotExist:
                new_user = User.objects.create(
                    email = user.email,
                    username = user.first_name + user.last_name,
                    firstname = user.first_name,
                    lastname = user.last_name,
                    aadhar_number = user.uid,
                    phone_number = user.phone,
                    DOB = user.dob,
                    gender = user.gender
                )

                Address.objects.create(
                    user = new_user,
                    house_number = user.house_number,
                    locality = user.locality,
                    landmark = user.landmark,
                    street = user.street,
                    district = user.district,
                    state = user.state,
                    pincode = user.pincode,
                    type = 'Home'
                )

                number = '+91' + str(user.phone)
                try:
                    verifyPhone.send(number)
                except:
                    return JsonResponse({'error':"Activation Link has expired"}, status=status.HTTP_404_NOT_FOUND)
                content = {'detail': 'OTP sent'}
                return JsonResponse(content, status = status.HTTP_200_OK) 
            content = {'detail': 'User already exists try login'}
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
                if user.is_active:
                    tokens = RefreshToken.for_user(user=user)
                    content = {
                        'message' : "Phone successfully verified",
                        'username': (user.username),
                        'refresh': str(tokens),
                        'access': str(tokens.access_token)
                    }
                    return JsonResponse(content, status=status.HTTP_200_OK)
                return JsonResponse({'error':"Code Expired"}, status=status.HTTP_400_BAD_REQUEST)
            return JsonResponse({'error':"User with this aadhar number does not exist"}, status=status.HTTP_400_BAD_REQUEST)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST) 


class SetUsernamePasswordView(generics.GenericAPIView):
    serializer_class = SetPasswordSerializer
    permission_classes = [IsAuthenticated]

    def post(self,request):
        print(request.user)
        try:
            user = User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid(): 
            user.username = serializer.validated_data['username'] 
            user.set_password(serializer.validated_data['password'])
            user.save()
            return JsonResponse({'message':'password successfully set'}, status = status.HTTP_202_ACCEPTED)
        return JsonResponse(serializer.errors, status = status.HTTP_404_NOT_FOUND)
    

class Login(generics.GenericAPIView):

    serializer_class = LoginSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request':request})
        serializer.is_valid(raise_exception=True)
        return JsonResponse(serializer.validated_data, status=status.HTTP_200_OK)
    



class UserView(generics.GenericAPIView):
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated,]

    def get(self,request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        userProfile = UserSerializer(user, many=False, context={'request': request})
        return JsonResponse(userProfile.data,safe=False,status = status.HTTP_200_OK)


    def patch(self,request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = UserSerializer(instance = user, data=request.data, partial = True)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data,safe=False,status = status.HTTP_200_OK)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST)


    def delete(self,request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        user.delete()
        content = {'detail': 'User Deleted'}
        return JsonResponse(content, status = status.HTTP_202_ACCEPTED)


class AddressView(generics.GenericAPIView):
    serializer_class = AddressSerializer
    permission_classes = [IsAuthenticated,]

    def get(self,request, pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        if pk == 'All':
            address = Address.objects.filter(user = user)
            userAddress = AddressSerializer(address, many=True, context={'request': request})
            return JsonResponse(userAddress.data,safe=False,status = status.HTTP_200_OK)
        else:
            if Address.objects.filter(user = user, type = pk).exists():
                address = Address.objects.filter(user = user, type = pk)
                userAddress = AddressSerializer(address, many=True, context={'request': request})
                return JsonResponse(userAddress.data,safe=False,status = status.HTTP_200_OK)
            else:
                content = {'Message' : 'Available types of Address are (All, Primary, Secondary, Work, Home, Other) enter one'}
                return JsonResponse(content, safe = False, status = status.HTTP_404_NOT_FOUND)
        
    def post(self, request, pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        address = Address(user = request.user)
        serializer = AddressSerializer(address, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data,safe=False, status = status.HTTP_202_ACCEPTED)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST) 

    def patch(self, request, pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        try:
            address=Address.objects.get(id = pk, user = user)
        except Address.DoesNotExist:
            content = {'detail': 'No such address belongs to the user'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = AddressSerializer(instance = address, data=request.data, partial = True)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data,safe=False,status = status.HTTP_200_OK)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
    
    def delete(self,request,pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        try:
            address=Address.objects.get(id = pk, user = user)
        except address.DoesNotExist:
            content = {'detail': 'No such address belongs to the user'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        address.delete()
        content = {'detail': 'Address Deleted'}
        return JsonResponse(content, status = status.HTTP_202_ACCEPTED)
        

class EmergencyContactView(generics.GenericAPIView):
    serializer_class = EmergencyContactSerializer
    permission_classes = [IsAuthenticated,]

    def get(self,request,pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        emergency = EmergencyContact.objects.filter(user = user)
        userEmergencyContact = EmergencyContactSerializer(emergency, many=True, context={'request': request})
        return JsonResponse(userEmergencyContact.data,safe=False,status = status.HTTP_200_OK)

        
    def post(self, request,pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        emergency = EmergencyContact(user = request.user)
        serializer = EmergencyContactSerializer(emergency, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data,safe=False, status = status.HTTP_202_ACCEPTED)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST) 

    def patch(self, request, pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        try:
            emergency=EmergencyContact.objects.get(id = pk, user = user)
        except EmergencyContact.DoesNotExist:
            content = {'detail': 'No such emergency contact belongs to the user'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = EmergencyContactSerializer(instance = emergency, data=request.data, partial = True)
        if serializer.is_valid():
            serializer.save()
            return JsonResponse(serializer.data,safe=False,status = status.HTTP_200_OK)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST)
    
    def delete(self,request,pk):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        try:
            emergency=EmergencyContact.objects.get(id = pk, user = user)
        except EmergencyContact.DoesNotExist:
            content = {'detail': 'No such emergency contact belongs to the user'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        emergency.delete()
        content = {'detail': 'Emergency Deleted'}
        return JsonResponse(content, status = status.HTTP_202_ACCEPTED)
    

class GetUserList(generics.ListCreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [IsAuthenticated]