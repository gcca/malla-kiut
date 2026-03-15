#pragma once

#include <QIdentityProxyModel>
#include <QSqlDatabase>
#include <QSqlTableModel>

class TableModel : public QIdentityProxyModel {
  Q_OBJECT
  Q_PROPERTY(bool dirty READ isDirty NOTIFY dirtyChanged)
  Q_PROPERTY(QString currentTable READ currentTable NOTIFY currentTableChanged)

public:
  static constexpr int ModifiedRole = Qt::UserRole + 1;

  explicit TableModel(QObject *parent = nullptr);

  void setTable(const QString &tableName, const QSqlDatabase &db);

  QHash<int, QByteArray> roleNames() const override;
  QVariant data(const QModelIndex &index,
                int role = Qt::DisplayRole) const override;
  bool setData(const QModelIndex &index, const QVariant &value,
               int role = Qt::EditRole) override;

  bool isDirty() const;
  QString currentTable() const;

public slots:
  bool commit();
  void revert() override;
  bool insertRow();

signals:
  void dirtyChanged();
  void currentTableChanged();
  void errorOccurred(const QString &message);

private:
  QSqlTableModel *m_sqlModel = nullptr;
  QString m_currentTable;
};
