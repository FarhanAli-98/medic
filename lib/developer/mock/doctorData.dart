// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

const MOCK_DOCTOR_DATA = [
  {
    'uid': '1',
    'name': 'Alice',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'specialities': ['NUROLOGIST', 'NUROLOGIST', 'NUROLOGIST'],
    'imageUrl':
        'http://wwsthemes.com/themes/medwise/v1.3/images/doctor-single.jpg',
    'experience': '5',
    'rating': '4.5',
    'fee': '350',
  },
  {
    'uid': '2',
    'name': 'Matt',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'specialities': ['NUROLOGIST'],
    'imageUrl':
        'http://medcare-demo.detheme.com/video/wp-content/uploads/sites/6/2016/02/doctor-profile03.jpg',
    'experience': '3',
    'rating': '4.5',
    'fee': '500',
  },
  {
    'uid': '3',
    'name': 'Janet',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'specialities': ['PROCTOLOGIST'],
    'imageUrl':
        'http://s7606.pcdn.co/wp-content/uploads/2016/07/Dr.-Naila-Alam.jpg',
    'experience': '5',
    'rating': '4.5',
    'fee': '350',
  },
  {
    'uid': '4',
    'name': 'Robert',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'specialities': ['NUROLOGIST'],
    'imageUrl':
        'https://www.browardhealth.org/-/media/BH_Doctor_Images/108634.png',
    'experience': '15',
    'rating': '4.5',
    'fee': '350',
  },
  {
    'uid': '5',
    'name': 'Harvinder Singh',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'specialities': ['General Physician'],
    'imageUrl':
        'https://shrimannhospitals.com/uploads/1558072620-drjssaini.jpg',
    'experience': '25',
    'rating': '4.5',
    'fee': '350',
  },
  {
    'uid': '1',
    'name': 'Alice',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'specialities': ['NUROLOGIST'],
    'imageUrl':
        'http://wwsthemes.com/themes/medwise/v1.3/images/doctor-single.jpg',
    'experience': '5',
    'rating': '4.5',
    'fee': '350',
  },
  {
    'uid': '2',
    'name': 'Matt',
    'bio':
        'This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.This is some info about me.',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'specialities': ['NUROLOGIST'],
    'imageUrl':
        'http://medcare-demo.detheme.com/video/wp-content/uploads/sites/6/2016/02/doctor-profile03.jpg',
    'experience': '3',
    'rating': '4.5',
    'fee': '500',
  },
];
