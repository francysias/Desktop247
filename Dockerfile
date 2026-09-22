# Usa un'immagine ufficiale PHP con Apache
FROM php:8.1-apache

# Installa le dipendenze di sistema e le estensioni PHP comunemente richieste da CMS/gestionali (es. pdo, pdo_mysql, mysqli, gd, zip)
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) pdo pdo_mysql mysqli gd zip

# Abilita mod_rewrite di Apache (spesso necessario per i link delle app web)
RUN a2enmod rewrite

# Modifica la configurazione di Apache affinché ascolti sulla porta dinamica di Render ($PORT)
# Di default Apache usa la porta 80, Render richiede di usare la variabile ${PORT}
ENV PORT=10000
RUN sed -i "s/80/\${PORT}/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

# Copia i file del tuo progetto all'interno della cartella pubblica di Apache
COPY . /var/www/html/

# Imposta i permessi corretti per la cartella web
RUN chown -R www-data:www-data /var/www/html

# Espone la porta (Render usa la porta configurata nell'ambiente)
EXPOSE 10000
