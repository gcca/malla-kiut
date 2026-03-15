#include "table_model.h"

#include <QSqlError>

TableModel::TableModel(QObject *parent) : QIdentityProxyModel(parent) {}

void TableModel::setTable(const QString &tableName, const QSqlDatabase &db) {
  if (m_sqlModel)
    m_sqlModel->deleteLater();
  m_sqlModel = new QSqlTableModel(this, db);
  m_sqlModel->setEditStrategy(QSqlTableModel::OnManualSubmit);
  m_sqlModel->setTable(tableName);
  m_sqlModel->select();
  setSourceModel(m_sqlModel);
  m_currentTable = tableName;
  emit currentTableChanged();
  emit dirtyChanged();
}

QHash<int, QByteArray> TableModel::roleNames() const {
  auto roles = QIdentityProxyModel::roleNames();
  roles.insert(ModifiedRole, "modified");
  return roles;
}

QVariant TableModel::data(const QModelIndex &index, int role) const {
  if (role == ModifiedRole && m_sqlModel)
    return m_sqlModel->isDirty(mapToSource(index));
  return QIdentityProxyModel::data(index, role);
}

bool TableModel::setData(const QModelIndex &index, const QVariant &value,
                         int role) {
  bool ok = QIdentityProxyModel::setData(index, value, role);
  if (ok)
    emit dirtyChanged();
  return ok;
}

QString TableModel::currentTable() const { return m_currentTable; }

bool TableModel::isDirty() const {
  return m_sqlModel && m_sqlModel->isDirty();
}

bool TableModel::commit() {
  if (!m_sqlModel)
    return false;
  bool ok = m_sqlModel->submitAll();
  if (!ok)
    emit errorOccurred(m_sqlModel->lastError().text());
  emit dirtyChanged();
  return ok;
}

void TableModel::revert() {
  if (m_sqlModel) {
    m_sqlModel->revertAll();
    emit dirtyChanged();
  }
}

bool TableModel::insertRow() {
  if (!m_sqlModel)
    return false;
  int row = m_sqlModel->rowCount();
  bool ok = m_sqlModel->insertRow(row);
  if (ok)
    emit dirtyChanged();
  return ok;
}
