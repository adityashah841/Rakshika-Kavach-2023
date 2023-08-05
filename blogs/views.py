from django.shortcuts import render
from django.http.response import HttpResponse, JsonResponse
import jwt
from rest_framework.views import APIView
from rest_framework import (mixins, generics, status, permissions)
from rest_framework.response import Response
from .models import *
from .serializers import *
from drf_yasg import openapi
from drf_yasg.utils import swagger_auto_schema
from rest_framework.permissions import IsAuthenticated
import pytz

# Create your views here.
class BlogsView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = BlogSerializer
    @swagger_auto_schema(
        operation_description="Get all blogs",
    )
    def get(self, request,pk):
        blogs = Blog.objects.all()
        serializer = self.serializer_class(blogs, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @swagger_auto_schema(
        operation_description="Create a blog",
    #     request_body=openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ),
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )
    def post(self, request,pk):
        serializer = self.serializer_class(data=request.data)
        # print(serializer.initial_data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    # Add a method to update an existing blog, where blog can be identified by its title and author, and also add the updated_at date at this time (ignore the last part if it is already being handled in models)

    @swagger_auto_schema(
        operation_description="Update a blog",
    #     request_body=openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ),
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )
    def patch(self, request,pk):
        try:
            blog = Blog.objects.get(id = pk)
        except Blog.DoesNotExist:
            content = {'detail': 'No such blog exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        serializer = BlogSerializer(instance=blog, data=request.data, partial = True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    # Add a method to delete an existing blog, where blog can be identified by its title and author

    # generate swagger auto schema for delete API for parameter title (which is separate from the request_body)


    @swagger_auto_schema(
        operation_description="Delete a blog",
        
    #     responses={200: openapi.Response('OK', openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'title': openapi.Schema(type=openapi.TYPE_STRING),
    #             'content': openapi.Schema(type=openapi.TYPE_STRING),
    #             'author': openapi.Schema(type=openapi.TYPE_STRING),
    #             'created_at': openapi.Schema(type=openapi.TYPE_STRING),
    #             'updated_at': openapi.Schema(type=openapi.TYPE_STRING),
    #         }
    #     ))},
    )

    def delete(self, request,pk):
        try:
            blog = Blog.objects.get(id = pk)
        except Blog.DoesNotExist:
            content = {'detail': 'No such blog exists'}
            return JsonResponse(content, status = status.HTTP_404_NOT_FOUND)
        blog.delete()
        content = {'detail': 'Blog Deleted'}
        return JsonResponse(content, status = status.HTTP_202_ACCEPTED)