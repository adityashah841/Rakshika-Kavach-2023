from django.shortcuts import render
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.response import Response
from .models import EFir
from .serializers import *
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
from rest_framework.parsers import MultiPartParser, FormParser
from django.conf import settings
from django.contrib.auth import get_user_model
import base64
from django.core.mail import EmailMultiAlternatives
from django.conf import settings
from django.core.files.base import ContentFile
import requests
from cloudinary.utils import cloudinary_url

User = get_user_model()

def send_email_with_cloud_attachments(to_email, subject, message):
    from_email = settings.DEFAULT_FROM_EMAIL
    msg = EmailMultiAlternatives(subject, message, from_email, [to_email])
    msg.send()

# Create your views here.
class EFirView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = EFirSerializer
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request):
        try:
            user = User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        efir = EFir(user = request.user)
        serializer = self.serializer_class(efir, data = request.data)
        if serializer.is_valid():
            serializer.save()
            send_email_with_cloud_attachments(
                # to_email=request.user.email,
                to_email=settings.DEFAULT_FROM_EMAIL,
                subject='E-FIR Recorded',
                # message=f"Your evidence has been uploaded successfully.\nVideo URL: {cloudinary_url(serializer.validated_data['video'].name)[0]}\nAudio URL: {cloudinary_url(serializer.validated_data['audio'].name)[0]}",
                message="Your E-FIR has been successfully recorded. Login to Rakshika app to track the status of your E-FIR."
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return JsonResponse({'error': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
    
class EFirAdminView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = EFirSerializer
    parser_classes = (MultiPartParser, FormParser)

    @swagger_auto_schema(operation_description="Get all E-FIRs / Get E-FIRs by status\nTo get all E-FIRs, pass 'all' as the status")
    def get(self, request, efir_status):
        try:
            user = User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        if efir_status == 'all':
            efir = EFir.objects.all()
        else:
            efir = EFir.objects.filter(status = efir_status)
        serializer = self.serializer_class(efir, many = True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class EFirAdminUpdateView(generics.GenericAPIView):
    serializer_class = EFirUpdateSerializer
    permission_classes = (IsAuthenticated,)

    @swagger_auto_schema(operation_description="Update E-FIR status", request_body=serializer_class)
    def patch(self, request, id):
        try:
            efir = EFir.objects.get(id = id)
        except EFir.DoesNotExist:
            content = {'detail': 'No such E-FIR exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = self.serializer_class(efir, data = request.data, partial = True)
        if serializer.is_valid():
            serializer.save()
            send_email_with_cloud_attachments(
                to_email=efir.user.email,
                subject='E-FIR Status Updated',
                message=f"Your E-FIR status has been updated to {request.data['status']}. Login to Rakshika app to track the status of your E-FIR."
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return JsonResponse({'error': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)