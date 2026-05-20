"""Сериализаторы приложения accounts."""

from rest_framework import serializers

from .models import LoginCode, User


class UserSerializer(serializers.ModelSerializer):
    """Публичное представление пользователя (профиль, ответ авторизации)."""

    display_name = serializers.CharField(read_only=True)

    class Meta:
        model = User
        fields = ('id', 'email', 'first_name', 'last_name', 'chat_display_name', 'display_name')
        read_only_fields = ('id', 'email')


class RegisterSerializer(serializers.Serializer):
    """Регистрация: e-mail, имя и фамилия. Пароль не используется."""

    email = serializers.EmailField()
    first_name = serializers.CharField(max_length=150)
    last_name = serializers.CharField(max_length=150)

    def validate_email(self, value):
        if User.objects.filter(email__iexact=value).exists():
            raise serializers.ValidationError('Этот e-mail уже зарегистрирован.')
        return value

    def create(self, validated_data):
        return User.objects.create_user(**validated_data)


class RequestCodeSerializer(serializers.Serializer):
    """Запрос одноразового кода для входа по уже зарегистрированному e-mail."""

    email = serializers.EmailField()


class VerifySerializer(serializers.Serializer):
    """Проверка одноразового кода. При успехе кладёт пользователя в validated_data."""

    email = serializers.EmailField()
    code = serializers.CharField(min_length=6, max_length=6)

    default_error_messages = {
        'invalid': 'Неверный или просроченный код.',
    }

    def validate(self, attrs):
        user = User.objects.filter(email__iexact=attrs['email']).first()
        if user is None:
            self.fail('invalid')

        login_code = (
            LoginCode.objects.filter(user=user, consumed_at__isnull=True)
            .order_by('-created_at')
            .first()
        )
        if login_code is None or not login_code.verify(attrs['code']):
            self.fail('invalid')

        attrs['user'] = user
        return attrs
