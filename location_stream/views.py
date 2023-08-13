from django.shortcuts import render
from .models import *
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.response import Response
from accounts.models import *
from accounts.serializers import *
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated

class LocationStreamView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)

    @swagger_auto_schema(
        operation_description="Get continuous location after every 15 minutes",
        request_body=openapi.Schema(
            type=openapi.TYPE_OBJECT,
            properties={
                'latitude': openapi.Schema(type=openapi.TYPE_STRING),
                'longitude': openapi.Schema(type=openapi.TYPE_STRING),
            }
    ))

    def post(self, request):
        try:
            user=User.objects.get(aadhar_number = request.user.aadhar_number)
        except User.DoesNotExist:
            content = {'detail': 'No such user exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = UserSerializer(instance = user, data=request.data, partial = True)
        if serializer.is_valid():
            # print(serializer.validated_data["latitude"])
            # print(serializer.validated_data["longitude"])
            serializer.save()
            return JsonResponse(serializer.data,safe=False,status = status.HTTP_200_OK)
        return JsonResponse(serializer.errors, status = status.HTTP_400_BAD_REQUEST)