import pytest


def test_chrony_package_installed(host):
    """Пакет chrony должен быть установлен."""
    chrony = host.package("chrony")
    assert chrony.is_installed, "Пакет chrony не установлен"


def test_chrony_config_file_exists(host):
    """Файл конфигурации должен существовать с правильными правами."""
    config = host.file("/etc/chrony/chrony.conf")
    assert config.exists, "Файл /etc/chrony/chrony.conf не найден"
    assert config.is_file, "/etc/chrony/chrony.conf не является файлом"
    assert config.user == "root", f"Владелец файла: {config.user}, ожидался root"
    assert config.group == "root", f"Группа файла: {config.group}, ожидалась root"
    assert config.mode == 0o644, f"Права файла: {oct(config.mode)}, ожидались 0o644"


def test_timezone_is_europe_moscow(host):
    """Системная временная зона должна быть Europe/Moscow."""
    localtime = host.file("/etc/localtime")
    assert localtime.is_symlink, "/etc/localtime не является симлинком"
    assert "Europe/Moscow" in localtime.linked_to, (
        f"Временная зона не Europe/Moscow, а {localtime.linked_to}"
    )


def test_timezone_command(host):
    """Дополнительная проверка временной зоны через timedatectl."""
    result = host.run("timedatectl show --property=Timezone --value")
    assert result.rc == 0, "timedatectl завершился с ошибкой"
    assert result.stdout.strip() == "Europe/Moscow", (
        f"timedatectl вернул {result.stdout.strip()}"
    )


def test_chronyd_service_running(host):
    """Сервис chronyd должен быть запущен."""
    service = host.service("chronyd")
    assert service.exists, "Сервис chronyd не найден"
    assert service.is_running, "Сервис chronyd не запущен"


def test_chronyd_service_enabled(host):
    """Сервис chronyd должен быть в автозагрузке."""
    service = host.service("chronyd")
    assert service.is_enabled, "Сервис chronyd не включён в автозагрузку"