from django.urls import path
from . import views

urlpatterns = [
    path('', views.EvidenceView.as_view(), name="Evidences"),
    path('<int:user_id>/', views.EvidenceListView.as_view(), name="Evidences"),
    path('<str:location>/', views.EvidenceListView.as_view(), name="Evidences"),
]