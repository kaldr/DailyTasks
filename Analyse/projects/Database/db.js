(function() {
  ({
    source: {
      db: {
        ip: '218.244.158.177',
        port: 27200,
        username: 'huangyu',
        password: 'huangyu',
        db: 'erp'
      },
      dajie: {
        collection: 'DisneyTicketStock'
      }
    },
    destination: {
      db: {
        ip: '218.244.158.177',
        port: 27200,
        username: 'huangyu',
        password: 'huangyu',
        db: 'DatabaseTasks'
      },
      dajie: {
        collection: 'DisneyTicketReservationHistory'
      }
    }
  });

}).call(this);
