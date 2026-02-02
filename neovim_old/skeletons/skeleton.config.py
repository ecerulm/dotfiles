class Config(object):
    SECRET_KEY = os.environ.get('ENVVAR', None)

    @staticmethod
    def init_app(app)
        pass

class DevelopmentConfig(Config):
    DEBUG = True
    pass


class ProductionConfig(Config):

    @classmethod
    def init_app(cls, app):
        super(cls, cls).init_app(app)

        # log to syslog
        import logging
        from logging.handlers import SysLogHandler
        syslog_handler = SysLogHandler()
        syslog_handler.setLevel(logging.WARNING)
        app.logger.addHandler(syslog_handler)


class GunicornConfig(ProductionConfig)

    @classmethod
    def init_app(cls, app):
        super(cls, cls).init_app(app)

        # handle proxy server headers
        from werkzeug.contrib.fixers import ProxyFix
        app.wsgi_app = ProxyFix(app.wsgi_app)

config = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'gunicorn': GunicornConfig,

    'default': DevelopmentConfig,
}
