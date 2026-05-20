"""Маршруты авторизации и профиля (монтируются под /api/auth/)."""

from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from .views import MeView, RegisterView, RequestCodeView, VerifyView

urlpatterns = [
    path('register/', RegisterView.as_view(), name='auth-register'),
    path('request-code/', RequestCodeView.as_view(), name='auth-request-code'),
    path('verify/', VerifyView.as_view(), name='auth-verify'),
    path('refresh/', TokenRefreshView.as_view(), name='auth-refresh'),
    path('me/', MeView.as_view(), name='auth-me'),
]
