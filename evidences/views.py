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
from rest_framework.parsers import MultiPartParser, FormParser
from django.conf import settings
from .ml import extract_faces

class EvidenceView(generics.GenericAPIView):
    # permission_classes = (IsAuthenticated,)
    serializer_class = EvidenceSerializer
    parser_classes = (MultiPartParser, FormParser)

    # @swagger_auto_schema(
    #     operation_description="Create a new evidence",
    #     request_body=openapi.Schema(
    #         type=openapi.TYPE_OBJECT,
    #         properties={
    #             'user_id': openapi.Schema(type=openapi.TYPE_INTEGER),
    #             'location': openapi.Schema(type=openapi.TYPE_STRING),
    #             'source': openapi.Schema(type=openapi.TYPE_STRING),
    #             'destination': openapi.Schema(type=openapi.TYPE_STRING),
    #             'planned_route': openapi.Schema(type=openapi.TYPE_OBJECT),
    #             'isolated_zone_flag': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #             'authority_contacted': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #             'action_taken': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #             'action': openapi.Schema(type=openapi.TYPE_STRING),
    #             'action_taken_by': openapi.Schema(type=openapi.TYPE_STRING),
    #             'video': openapi.Schema(type=openapi.TYPE_FILE),
    #             'audio': openapi.Schema(type=openapi.TYPE_FILE),
    #         },
    #     ),
    #     responses={
    #         201: openapi.Response(
    #             description="Evidence created successfully",
    #             schema=openapi.Schema(
    #                 type=openapi.TYPE_OBJECT,
    #                 properties={
    #                     'id': openapi.Schema(type=openapi.TYPE_INTEGER),
    #                     'user_id': openapi.Schema(type=openapi.TYPE_INTEGER),
    #                     'timestamp': openapi.Schema(type=openapi.TYPE_STRING),
    #                     'location': openapi.Schema(type=openapi.TYPE_STRING),
    #                     'source': openapi.Schema(type=openapi.TYPE_STRING),
    #                     'destination': openapi.Schema(type=openapi.TYPE_STRING),
    #                     'planned_route': openapi.Schema(type=openapi.TYPE_OBJECT),
    #                     'isolated_zone_flag': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #                     'authority_contacted': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #                     'action_taken': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #                     'action': openapi.Schema(type=openapi.TYPE_STRING),
    #                     'action_taken_by': openapi.Schema(type=openapi.TYPE_STRING),
    #                     'action_taken_timestamp': openapi.Schema(type=openapi.TYPE_STRING),
    #                 },
    #             ),
    #         ),
    #         400: openapi.Response(
    #             description="Bad request",
    #             schema=openapi.Schema(
    #                 type=openapi.TYPE_OBJECT,
    #                 properties={
    #                     'error': openapi.Schema(type=openapi.TYPE_STRING),
    #                 },
    #             ),
    #         ),
    #     },
    # )
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        if serializer.is_valid():
            evidence, created = Evidence.objects.get_or_create(**serializer.validated_data)
            if created:
                # Extract faces from the video received
                faces = extract_faces(evidence.video.path)
                # Create suspects for each extracted face 
                for face_image in faces:
                    suspect = Suspect.objects.create(evidence=evidence, image=face_image)
                    evidence.suspect_set.add(suspect)
            # serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return JsonResponse({'error': serializer.errors}, status=status.HTTP_400_BAD_REQUEST)
            
class EvidenceListView(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = EvidenceSerializer

    # @swagger_auto_schema(
    #     operation_description="Get evidences by user id",
    #     responses={
    #         200: openapi.Response(
    #             description="Evidences retrieved successfully",
    #             schema=openapi.Schema(
    #                 type=openapi.TYPE_ARRAY,
    #                 items=openapi.Schema(
    #                     type=openapi.TYPE_OBJECT,
    #                     properties={
    #                         'id': openapi.Schema(type=openapi.TYPE_INTEGER),
    #                         'user_id': openapi.Schema(type=openapi.TYPE_INTEGER),
    #                         'timestamp': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'location': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'source': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'destination': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'planned_route': openapi.Schema(type=openapi.TYPE_OBJECT),
    #                         'isolated_zone_flag': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #                         'authority_contacted': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #                         'action_taken': openapi.Schema(type=openapi.TYPE_BOOLEAN),
    #                         'action': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'action_taken_by': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'action_taken_timestamp': openapi.Schema(type=openapi.TYPE_STRING),
    #                     },
    #                 ),
    #             ),
    #         ),
    #         400: openapi.Response(
    #             description="Bad request",
    #             schema=openapi.Schema(
    #                 type=openapi.TYPE_OBJECT,
    #                 properties={
    #                     'error': openapi.Schema(type=openapi.TYPE_STRING),
    #                 },
    #             ),
    #         ),
    #     },
    # )
    def get(self, request, user_id):
        evidences = Evidence.objects.filter(user_id=user_id)
        if evidences.count() == 0:
            return JsonResponse({'error': 'No evidences found for this user'}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.serializer_class(evidences, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def get(self, request, location):
        evidences = Evidence.objects.filter(location = location)
        if evidences.count() == 0:
            return JsonResponse({'error': 'No evidences found for this location'}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.serializer_class(evidences, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class Suspects(generics.GenericAPIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = SuspectSerializer

    # Create view to get all suspects related to an evidence
    # @swagger_auto_schema(
    #     operation_description="Get all suspects related to an evidence",
    #     responses={
    #         200: openapi.Response(
    #             description="Suspects retrieved successfully",
    #             schema=openapi.Schema(
    #                 type=openapi.TYPE_ARRAY,
    #                 items=openapi.Schema(
    #                     type=openapi.TYPE_OBJECT,
    #                     properties={
    #                         'id': openapi.Schema(type=openapi.TYPE_INTEGER),
    #                         'name': openapi.Schema(type=openapi.TYPE_STRING),
    #                         'image': openapi.Schema(type=openapi.TYPE_STRING),
    #                     },
    #                 ),
    #             ),
    #         ),
    #         400: openapi.Response(
    #             description="Bad request",
    #             schema=openapi.Schema(
    #                 type=openapi.TYPE_OBJECT,
    #                 properties={
    #                     'error': openapi.Schema(type=openapi.TYPE_STRING),
    #                 },
    #             ),
    #         ),
    #     },
    # )
    def get(self, request, evidence_id):
        evidence = Evidence.objects.get(id=evidence_id)
        suspects = evidence.suspect_set.all()
        if suspects.count() == 0:
            return JsonResponse({'error': 'No suspects found for this evidence'}, status=status.HTTP_400_BAD_REQUEST)
        serializer = self.serializer_class(suspects, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
