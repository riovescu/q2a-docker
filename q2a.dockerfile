FROM php:7.2-apache

WORKDIR /var/www/html/q2a

ENV QA_CONFIG qa-config.php

RUN apt-get update \
        && apt-get install -y --no-install-recommends \
             unzip \
             git   \
        && rm -r /var/lib/apt/lists/*


RUN echo "download q2a" \
 && curl -o /q2a.zip https://www.question2answer.org/question2answer-latest.zip \
 && unzip /q2a.zip -d /q2a \
 && mv /q2a/*/* . \
 && rm /q2a.zip                \
 && rm -rf /q2a


RUN echo "get plugins and themes"                                                                          \
 && echo "git clone https://github.com/alixandru/q2a-open-login.git              qa-plugin/qa-open-login"         \
 && git clone https://github.com/ganbox/qa-filter.git                      qa-plugin/qa-filter             \
 && git clone https://github.com/NoahY/q2a-poll.git                        qa-plugin/qa-poll               \
 && git clone https://github.com/svivian/q2a-user-activity-plus.git        qa-plugin/qa-user-activity      \
 && git clone https://github.com/NoahY/q2a-history.git                     qa-plugin/qa-user-history       \
 && git clone https://github.com/NoahY/q2a-log-tags.git                    qa-plugin/qa-log-tags           \
 && git clone https://github.com/dunse/qa-category-email-notifications.git qa-plugin/qa-email-notification \
 && git clone https://github.com/nakov/q2a-plugin-open-questions.git       qa-plugin/qa-questions-open     \
 && git clone https://github.com/q2a-projects/CleanStrap.git               qa-theme/cleanStrap             \
 && git clone https://github.com/svivian/q2a-markdown-editor.git           qa-plugin/markdown-editor

#RUN echo "move login providers"  \
# && mv qa-plugin/qa-open-login/providers-sample.php qa-plugin/qa-open-login/providers.php

RUN echo "update configuration" \
 && mv qa-config-example.php ${QA_CONFIG}                                              \
 && sed -i -e 's/127.0.0.1/mysqldb/g' ${QA_CONFIG}                                     \
 && sed -i -e "s/'your-mysql-username'/getenv('QA_DB_USER')/g" ${QA_CONFIG}            \
 && sed -i -e "s/'your-mysql-password'/getenv('QA_DB_PASS')/g" ${QA_CONFIG}            \
 && sed -i -e "s/'your-mysql-db-name'/getenv('QA_DB_NAME')/g"  ${QA_CONFIG}            \
 && echo "sed -i -e "s/SnowFlat/Donut-theme/" qa-include/app/options.php "             \
 && chown -R www-data:www-data .

RUN docker-php-ext-install mysqli

