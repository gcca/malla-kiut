#pragma once

#include <QObject>
#include <QSqlDatabase>
#include <QStringList>

class DatabaseManager : public QObject {
  Q_OBJECT
  Q_PROPERTY(QStringList tables READ tables NOTIFY tablesChanged)
  Q_PROPERTY(bool connected READ isConnected NOTIFY connectedChanged)

public:
  explicit DatabaseManager(QObject *parent = nullptr);

  QStringList tables() const;
  bool isConnected() const;
  QSqlDatabase database() const;

public slots:
  bool connectSQLite(const QUrl &fileUrl);
  bool connectPostgres(const QString &host, int port, const QString &dbName,
                       const QString &user, const QString &password);
  void selectTable(const QString &tableName);
  void disconnect();

signals:
  void tablesChanged();
  void connectedChanged();
  void tableSelected(const QString &tableName);
  void errorOccurred(const QString &message);

private:
  QSqlDatabase m_db;
  QStringList m_tables;
  bool m_connected = false;
  void refreshTables();
};
