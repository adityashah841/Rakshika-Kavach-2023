from django.urls import path
from . import views

urlpatterns = [
    path('', views.EvidenceView.as_view(), name="Evidences"),
    path('get_evidence/', views.EvidenceListView.as_view(), name="Evidences"),
    path('suspects/<int:evidence_id>/', views.SuspectsView.as_view(), name="Suspects"),
]