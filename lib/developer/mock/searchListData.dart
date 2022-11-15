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

const DOCTOR_LIST_DATA = [
  {
    'uid': '1',
    'name': 'Alice',
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
];

const HOSPITAL_LIST_DATA = [
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
  {
    'uid': '1',
    'rating':'4.5',
    'name': 'Hope Garden Hospital',
    'address': {
      'street': '28',
      'city': 'Winchester',
      'state': 'St.Valrico',
      'country': '',
      'pin': 'FL 33594'
    },
    'email': 'lgodlee0@wunderground.com',
    'contact': '606-98-8009',
    'imageUrl':
        'https://californiahealthline.org/wp-content/uploads/sites/3/2018/09/hospital-merger.jpg?w=1024',
  },
  {
    'uid': '2',
    'rating':'4.5',
    'name': 'Great Plains Community Hospital',
    'address': {
      'street': 'Thompson',
      'city': 'Matão',
      'state': null,
      'country': 'Brazil',
      'pin': '15990-000'
    },
    'email': 'dbunclark1@tumblr.com',
    'contact': '203-65-8070',
    'imageUrl':
        'https://img.freepik.com/free-vector/set-doctor-patient-cartoon-characters_36082-522.jpg?size=626&ext=jpg'
  },
  {
    'uid': '3',
    'rating':'4.5',
    'name': 'Magnolia Clinic',
    'address': {
      'street': 'Sachtjen',
      'city': 'Wangshi',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'hcaulder2@miibeian.gov.cn',
    'contact': '578-96-1601',
    'imageUrl':
        'https://orbograph.com/wp-content/uploads/2018/09/rural_hospital.png',
  },
  {
    'uid': '4',
    'rating':'4.5',
    'name': 'Oasis Medical Clinic',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'rgoodbanne3@nhs.uk',
    'contact': '536-35-1642',
    'imageUrl':
        'https://previews.123rf.com/images/mejn/mejn1802/mejn180200017/95016523-hospital-flat-design-vector-illustration-with-ambulance-car-and-woman-with-baby-carriage-.jpg'
  },
  {
    'uid': '5',
    'rating':'4.5',
    'name': 'Morningside General Hospital',
    'address': {
      'street': 'Goodland',
      'city': 'Yucun',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'doveral4@constantcontact.com',
    'contact': '860-61-0169',
    'imageUrl': 'https://cdn4.vectorstock.com/i/1000x1000/80/93/hospital-building-and-ambulance-vector-9428093.jpg'
  },
  {
    'uid': '6',
    'rating':'4.5',
    'name': 'Woodland Hospital',
    'address': {
      'street': 'Dapin',
      'city': 'Meitang',
      'state': null,
      'country': 'China',
      'pin': null
    },
    'email': 'ytoffaloni5@dailymotion.com',
    'contact': '339-30-6798',
    'imageUrl': 'https://cdn2.vectorstock.com/i/1000x1000/65/56/medical-team-at-hospital-vector-20806556.jpg'
  },
];





