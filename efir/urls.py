from django.urls import path
from . import views

urlpatterns = [
    path('file_efir/', views.EFirView.as_view(), name='File E-FIR'),
    path('get_efirs/<str:efir_status>/', views.EFirAdminView.as_view(), name='Get E-FIRs'),
    path('update_efir/<str:id>/', views.EFirAdminUpdateView.as_view(), name='Update E-FIR'),
]