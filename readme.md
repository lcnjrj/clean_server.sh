# 🛡️ Linux Server Safe Cleanup
# Lu Faria
> Um script Bash robusto para manutenção e liberação segura de espaço em disco em servidores Linux (Debian/Ubuntu), focado em ambientes de produção.

![Bash](https://img.shields.io/badge/Shell_Script-Bash-4EAA25?style=flat&logo=gnu-bash&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)

## 📋 Sobre o Projeto

Como Administradores de Sistemas e Desenvolvedores, sabemos que scripts de limpeza agressivos (`rm -rf`) são perigosos. Este utilitário foi desenhado para atuar cirurgicamente em alvos seguros, removendo apenas o que é comprovadamente descartável, sem arriscar a integridade de aplicações rodando ou configurações críticas.

Ideal para manutenção de VPS, servidores dedicados e ambientes de CI/CD que acumulam cache rapidamente.

## 🚀 Funcionalidades

O script executa as seguintes operações sequenciais:

1.  **Limpeza do APT:** Executa `autoremove` e `clean` para remover pacotes órfãos e cache de instaladores `.deb`.
2.  **Otimização do Journald:** Reduz os logs do systemd mantendo apenas os últimos 2 dias ou limitando a 100MB (`vacuum`).
3.  **Rotação de Logs:** Remove arquivos de log antigos rotacionados (`*.gz`, `*.1`) em `/var/log`, sem tocar nos arquivos de log ativos.
4.  **Limpeza de Cache Root:** Remove thumbnails e caches temporários do usuário root.
5.  **Docker Prune (Opcional):** Seção comentada para limpeza de imagens e containers parados (útil para servidores de build/deploy).

## ⚠️ Aviso de Segurança

* **Não destrutivo:** Este script **não** limpa o diretório `/tmp` indiscriminadamente, pois isso pode quebrar sockets e arquivos de lock de aplicações em execução.
* **Logs Ativos:** Arquivos `.log` abertos não são deletados, prevenindo erros de "File Handle" em serviços como Nginx ou Apache.
* **Backup:** Embora seguro, recomenda-se sempre ter backups atualizados antes de rodar scripts de manutenção com privilégios de root.

## 🛠️ Instalação e Uso

### Pré-requisitos
* Distribuição Linux baseada em Debian (Ubuntu, Debian, Mint, Kali).
* Acesso `root` ou privilégios `sudo`.

### Executando o Script

1.  **Clone o repositório ou baixe o script:**
    ```bash
    git clone [https://github.com/SEU-USUARIO/linux-safe-cleanup.git](https://github.com/SEU-USUARIO/linux-safe-cleanup.git)
    cd linux-safe-cleanup
    ```

2.  **Dê permissão de execução:**
    ```bash
    chmod +x clean_server.sh
    ```

3.  **Execute como root:**
    ```bash
    sudo ./clean_server.sh
    ```

## ⚙️ Customização

### Docker Environment
Se você utiliza o servidor para hospedar containers, edite o arquivo `clean_server.sh` e descomente as linhas referentes ao Docker para habilitar o `docker system prune`:

```bash
# De:
# docker system prune -f

# Para:
docker system prune -f
