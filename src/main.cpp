#include <QApplication>
#include <QCommandLineParser>
#include <QFontDatabase>
#include <QIcon>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QStyleHints>
#include <QTranslator>

#include <QZXing.h>

#include <QtPlugin>
#if defined(QT_QPA_PLATFORM_MINIMAL)
Q_IMPORT_PLUGIN(QMinimalIntegrationPlugin);
#endif
#if defined(QT_QPA_PLATFORM_XCB)
Q_IMPORT_PLUGIN(QXcbIntegrationPlugin);
#elif defined(QT_QPA_PLATFORM_WINDOWS)
Q_IMPORT_PLUGIN(QWindowsIntegrationPlugin);
#elif defined(QT_QPA_PLATFORM_COCOA)
Q_IMPORT_PLUGIN(QCocoaIntegrationPlugin);
#endif

#ifdef _WIN32
#include <windows.h>
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setApplicationName("VPay");
    QCoreApplication::setOrganizationName("Palliums");
    QCoreApplication::setOrganizationDomain("palliums.org");
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QCoreApplication::setAttribute(Qt::AA_UseHighDpiPixmaps);
    QCoreApplication::setApplicationVersion(QT_STRINGIFY(VERSION));

    QApplication app(argc, argv);

    QCommandLineParser parser;
    parser.addHelpOption();
    parser.addVersionOption();
    parser.addOption(QCommandLineOption("printtoconsole"));
    parser.process(app);

    if (parser.isSet("printtoconsole")) {
#ifdef _WIN32
        if (AttachConsole(ATTACH_PARENT_PROCESS)) {
            freopen("CONOUT$", "w", stdout);
            freopen("CONOUT$", "w", stderr);
        }
#else
        Q_UNIMPLEMENTED();
#endif
    }

    QApplication::setWindowIcon(QIcon(":/icons/vpay.png"));

    // Reset the locale that is used for number formatting, see:
    // https://doc.qt.io/qt-5/qcoreapplication.html#locale-settings
    //setlocale(LC_NUMERIC, "C");

    const auto id = QFontDatabase::addApplicationFont(":/fonts/DINPro/DINPro-Regular.otf");
    Q_ASSERT(id >= 0);

    app.styleHints()->setTabFocusBehavior(Qt::TabFocusAllControls);

    const QLocale locale = QLocale::system();
    const QString language = locale.name().split('_').first();

    QTranslator english_translator;
    english_translator.load(":/i18n/vpay_en.qm");

    QTranslator language_translator;
    language_translator.load(QString(":/i18n/green_%1.qm").arg(language));

    QTranslator locale_translator;
    locale_translator.load(QString(":/i18n/green_%1.qm").arg(locale.name()));

    app.installTranslator(&english_translator);
    app.installTranslator(&language_translator);
    app.installTranslator(&locale_translator);

    //QQuickStyle::setStyle("Material");

    //qmlRegisterSingletonInstance<Clipboard>("Palliums.VPay.Core", 0, 1, "Clipboard", Clipboard::instance());

    QQmlApplicationEngine engine;
    engine.setBaseUrl(QUrl("qrc:/"));

    QZXing::registerQMLTypes();
    QZXing::registerQMLImageProvider(engine);

    engine.load(QUrl(QStringLiteral("main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
