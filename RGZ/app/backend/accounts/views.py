"""Эндпоинты авторизации без пароля и профиля пользователя."""

from rest_framework.generics import RetrieveUpdateAPIView
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from .models import LoginCode, User
from .serializers import (
    RegisterSerializer,
    RequestCodeSerializer,
    UserSerializer,
    VerifySerializer,
)
from .services import issue_and_send_code, issue_jwt_pair


class RegisterView(APIView):
    """Регистрация: создаёт пользователя и высылает код подтверждения."""

    permission_classes = [AllowAny]

    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        issue_and_send_code(user, LoginCode.PURPOSE_REGISTER)
        return Response({'detail': 'Код отправлен на ваш e-mail.'}, status=202)


class RequestCodeView(APIView):
    """Запрос кода для входа. Ответ одинаков вне зависимости от наличия e-mail."""

    permission_classes = [AllowAny]

    def post(self, request):
        serializer = RequestCodeSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = User.objects.filter(email__iexact=serializer.validated_data['email']).first()
        if user is not None:
            issue_and_send_code(user, LoginCode.PURPOSE_LOGIN)
        return Response({'detail': 'Если e-mail зарегистрирован, код отправлен.'})


class VerifyView(APIView):
    """Проверка одноразового кода — при успехе выдаёт пару JWT-токенов."""

    permission_classes = [AllowAny]

    def post(self, request):
        serializer = VerifySerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        tokens = issue_jwt_pair(user)
        return Response({**tokens, 'user': UserSerializer(user).data})


class MeView(RetrieveUpdateAPIView):
    """Текущий пользователь: чтение профиля и правка (в т.ч. имени в чате)."""

    permission_classes = [IsAuthenticated]
    serializer_class = UserSerializer

    def get_object(self):
        return self.request.user
