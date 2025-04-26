/****************************************************************************
** Meta object code from reading C++ file 'frequencymonitor.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.2)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "../../../../snippets/frequencymonitor/frequencymonitor.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'frequencymonitor.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.2. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_FrequencyMonitor_t {
    QByteArrayData data[22];
    char stringdata0[320];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_FrequencyMonitor_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_FrequencyMonitor_t qt_meta_stringdata_FrequencyMonitor = {
    {
QT_MOC_LITERAL(0, 0, 16), // "FrequencyMonitor"
QT_MOC_LITERAL(1, 17, 12), // "labelChanged"
QT_MOC_LITERAL(2, 30, 0), // ""
QT_MOC_LITERAL(3, 31, 5), // "value"
QT_MOC_LITERAL(4, 37, 13), // "activeChanged"
QT_MOC_LITERAL(5, 51, 23), // "samplingIntervalChanged"
QT_MOC_LITERAL(6, 75, 20), // "traceIntervalChanged"
QT_MOC_LITERAL(7, 96, 16), // "frequencyChanged"
QT_MOC_LITERAL(8, 113, 29), // "instantaneousFrequencyChanged"
QT_MOC_LITERAL(9, 143, 23), // "averageFrequencyChanged"
QT_MOC_LITERAL(10, 167, 6), // "notify"
QT_MOC_LITERAL(11, 174, 5), // "trace"
QT_MOC_LITERAL(12, 180, 9), // "setActive"
QT_MOC_LITERAL(13, 190, 8), // "setLabel"
QT_MOC_LITERAL(14, 199, 19), // "setSamplingInterval"
QT_MOC_LITERAL(15, 219, 16), // "setTraceInterval"
QT_MOC_LITERAL(16, 236, 5), // "label"
QT_MOC_LITERAL(17, 242, 6), // "active"
QT_MOC_LITERAL(18, 249, 16), // "samplingInterval"
QT_MOC_LITERAL(19, 266, 13), // "traceInterval"
QT_MOC_LITERAL(20, 280, 22), // "instantaneousFrequency"
QT_MOC_LITERAL(21, 303, 16) // "averageFrequency"

    },
    "FrequencyMonitor\0labelChanged\0\0value\0"
    "activeChanged\0samplingIntervalChanged\0"
    "traceIntervalChanged\0frequencyChanged\0"
    "instantaneousFrequencyChanged\0"
    "averageFrequencyChanged\0notify\0trace\0"
    "setActive\0setLabel\0setSamplingInterval\0"
    "setTraceInterval\0label\0active\0"
    "samplingInterval\0traceInterval\0"
    "instantaneousFrequency\0averageFrequency"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_FrequencyMonitor[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
      13,   14, // methods
       6,  112, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       7,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    1,   79,    2, 0x06 /* Public */,
       4,    1,   82,    2, 0x06 /* Public */,
       5,    1,   85,    2, 0x06 /* Public */,
       6,    1,   88,    2, 0x06 /* Public */,
       7,    0,   91,    2, 0x06 /* Public */,
       8,    1,   92,    2, 0x06 /* Public */,
       9,    1,   95,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
      10,    0,   98,    2, 0x0a /* Public */,
      11,    0,   99,    2, 0x0a /* Public */,
      12,    1,  100,    2, 0x0a /* Public */,
      13,    1,  103,    2, 0x0a /* Public */,
      14,    1,  106,    2, 0x0a /* Public */,
      15,    1,  109,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::Bool,    2,
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QReal,    3,
    QMetaType::Void, QMetaType::QReal,    3,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void,
    QMetaType::Void, QMetaType::Bool,    3,
    QMetaType::Void, QMetaType::QString,    3,
    QMetaType::Void, QMetaType::Int,    3,
    QMetaType::Void, QMetaType::Int,    3,

 // properties: name, type, flags
      16, QMetaType::QString, 0x00495103,
      17, QMetaType::Bool, 0x00495103,
      18, QMetaType::Int, 0x00495103,
      19, QMetaType::Int, 0x00495103,
      20, QMetaType::QReal, 0x00495001,
      21, QMetaType::QReal, 0x00495001,

 // properties: notify_signal_id
       0,
       1,
       2,
       3,
       5,
       6,

       0        // eod
};

void FrequencyMonitor::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<FrequencyMonitor *>(_o);
        Q_UNUSED(_t)
        switch (_id) {
        case 0: _t->labelChanged((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 1: _t->activeChanged((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 2: _t->samplingIntervalChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 3: _t->traceIntervalChanged((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 4: _t->frequencyChanged(); break;
        case 5: _t->instantaneousFrequencyChanged((*reinterpret_cast< qreal(*)>(_a[1]))); break;
        case 6: _t->averageFrequencyChanged((*reinterpret_cast< qreal(*)>(_a[1]))); break;
        case 7: _t->notify(); break;
        case 8: _t->trace(); break;
        case 9: _t->setActive((*reinterpret_cast< bool(*)>(_a[1]))); break;
        case 10: _t->setLabel((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 11: _t->setSamplingInterval((*reinterpret_cast< int(*)>(_a[1]))); break;
        case 12: _t->setTraceInterval((*reinterpret_cast< int(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (FrequencyMonitor::*)(const QString & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::labelChanged)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (FrequencyMonitor::*)(bool );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::activeChanged)) {
                *result = 1;
                return;
            }
        }
        {
            using _t = void (FrequencyMonitor::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::samplingIntervalChanged)) {
                *result = 2;
                return;
            }
        }
        {
            using _t = void (FrequencyMonitor::*)(int );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::traceIntervalChanged)) {
                *result = 3;
                return;
            }
        }
        {
            using _t = void (FrequencyMonitor::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::frequencyChanged)) {
                *result = 4;
                return;
            }
        }
        {
            using _t = void (FrequencyMonitor::*)(qreal );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::instantaneousFrequencyChanged)) {
                *result = 5;
                return;
            }
        }
        {
            using _t = void (FrequencyMonitor::*)(qreal );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&FrequencyMonitor::averageFrequencyChanged)) {
                *result = 6;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<FrequencyMonitor *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< QString*>(_v) = _t->label(); break;
        case 1: *reinterpret_cast< bool*>(_v) = _t->active(); break;
        case 2: *reinterpret_cast< int*>(_v) = _t->samplingInterval(); break;
        case 3: *reinterpret_cast< int*>(_v) = _t->traceInterval(); break;
        case 4: *reinterpret_cast< qreal*>(_v) = _t->instantaneousFrequency(); break;
        case 5: *reinterpret_cast< qreal*>(_v) = _t->averageFrequency(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<FrequencyMonitor *>(_o);
        Q_UNUSED(_t)
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setLabel(*reinterpret_cast< QString*>(_v)); break;
        case 1: _t->setActive(*reinterpret_cast< bool*>(_v)); break;
        case 2: _t->setSamplingInterval(*reinterpret_cast< int*>(_v)); break;
        case 3: _t->setTraceInterval(*reinterpret_cast< int*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject FrequencyMonitor::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_meta_stringdata_FrequencyMonitor.data,
    qt_meta_data_FrequencyMonitor,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *FrequencyMonitor::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *FrequencyMonitor::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_FrequencyMonitor.stringdata0))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int FrequencyMonitor::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 13)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 13;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 13)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 13;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 6;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void FrequencyMonitor::labelChanged(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 0, _a);
}

// SIGNAL 1
void FrequencyMonitor::activeChanged(bool _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}

// SIGNAL 2
void FrequencyMonitor::samplingIntervalChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 2, _a);
}

// SIGNAL 3
void FrequencyMonitor::traceIntervalChanged(int _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 3, _a);
}

// SIGNAL 4
void FrequencyMonitor::frequencyChanged()
{
    QMetaObject::activate(this, &staticMetaObject, 4, nullptr);
}

// SIGNAL 5
void FrequencyMonitor::instantaneousFrequencyChanged(qreal _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 5, _a);
}

// SIGNAL 6
void FrequencyMonitor::averageFrequencyChanged(qreal _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 6, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE
