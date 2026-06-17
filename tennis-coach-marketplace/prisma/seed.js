const { PrismaClient } = require('@prisma/client');
const bcrypt = require('bcryptjs');

const prisma = new PrismaClient();

const coaches = [
  {
    name: 'Rafael Martinez',
    email: 'rafael@tenniscoach.com',
    bio: 'Former ATP ranked player with 15 years of coaching experience. Specializes in baseline technique and mental game strategy. Has coached players from beginner to national level.',
    experience: 15,
    location: 'New York, NY',
    hourlyRate: 120,
    specialties: ['Advanced', 'Competitive', 'Mental Game'],
    rating: 4.9,
    totalReviews: 127,
  },
  {
    name: 'Serena Johnson',
    email: 'serena@tenniscoach.com',
    bio: 'Former NCAA Division I player with a passion for developing young talent. Expert in kids coaching and beginner programs. Creates fun, engaging sessions for all ages.',
    experience: 10,
    location: 'Los Angeles, CA',
    hourlyRate: 95,
    specialties: ['Kids', 'Beginner', 'Junior Development'],
    rating: 4.8,
    totalReviews: 98,
  },
  {
    name: 'Marcus Williams',
    email: 'marcus@tenniscoach.com',
    bio: 'USPTA certified professional coach. Specializes in serve mechanics and doubles strategy. Known for his analytical approach and video analysis sessions.',
    experience: 12,
    location: 'Chicago, IL',
    hourlyRate: 110,
    specialties: ['Advanced', 'Serve Technique', 'Doubles'],
    rating: 4.7,
    totalReviews: 84,
  },
  {
    name: 'Elena Petrova',
    email: 'elena@tenniscoach.com',
    bio: 'Former WTA tour player from Russia. Expert in Eastern European training methodologies. Focuses on footwork, court coverage, and tactical play.',
    experience: 8,
    location: 'Miami, FL',
    hourlyRate: 135,
    specialties: ['Advanced', 'Footwork', 'Tactics'],
    rating: 4.9,
    totalReviews: 61,
  },
  {
    name: 'David Chen',
    email: 'david@tenniscoach.com',
    bio: 'Patient and methodical coach perfect for adult beginners. Former college player turned full-time coach. Builds solid fundamentals with a focus on enjoyment and long-term improvement.',
    experience: 6,
    location: 'San Francisco, CA',
    hourlyRate: 75,
    specialties: ['Beginner', 'Adult Learners', 'Fundamentals'],
    rating: 4.6,
    totalReviews: 52,
  },
  {
    name: 'Alejandro Rivera',
    email: 'alejandro@tenniscoach.com',
    bio: 'ITF certified coach with experience training professional juniors. High-intensity training sessions for competitive players looking to take their game to the next level.',
    experience: 14,
    location: 'Houston, TX',
    hourlyRate: 150,
    specialties: ['Competitive', 'Junior Elite', 'Tournament Prep'],
    rating: 4.8,
    totalReviews: 73,
  },
  {
    name: 'Sophie Laurent',
    email: 'sophie@tenniscoach.com',
    bio: 'French-trained coach with a beautiful classical style. Expert in topspin groundstrokes and net play. Loves working with intermediate players wanting to break through plateaus.',
    experience: 9,
    location: 'Seattle, WA',
    hourlyRate: 90,
    specialties: ['Intermediate', 'Topspin', 'Net Play'],
    rating: 4.7,
    totalReviews: 45,
  },
  {
    name: 'James Thompson',
    email: 'james@tenniscoach.com',
    bio: 'Affordable and effective coaching for recreational players. Emphasizes fun while building real skills. Group sessions and private lessons available. Great with families.',
    experience: 7,
    location: 'Phoenix, AZ',
    hourlyRate: 60,
    specialties: ['Recreational', 'Beginner', 'Group Sessions'],
    rating: 4.5,
    totalReviews: 38,
  },
];

async function main() {
  console.log('Seeding database...');

  // Create admin user
  const adminPassword = await bcrypt.hash('admin123', 10);
  await prisma.user.upsert({
    where: { email: 'admin@tennismarket.com' },
    update: {},
    create: {
      name: 'Admin User',
      email: 'admin@tennismarket.com',
      password: adminPassword,
      role: 'admin',
    },
  });

  // Create demo student
  const studentPassword = await bcrypt.hash('student123', 10);
  await prisma.user.upsert({
    where: { email: 'student@demo.com' },
    update: {},
    create: {
      name: 'Alex Student',
      email: 'student@demo.com',
      password: studentPassword,
      role: 'student',
    },
  });

  // Create coaches
  for (const coachData of coaches) {
    const password = await bcrypt.hash('coach123', 10);
    const user = await prisma.user.upsert({
      where: { email: coachData.email },
      update: {},
      create: {
        name: coachData.name,
        email: coachData.email,
        password,
        role: 'coach',
      },
    });

    await prisma.coach.upsert({
      where: { userId: user.id },
      update: {},
      create: {
        userId: user.id,
        bio: coachData.bio,
        experience: coachData.experience,
        location: coachData.location,
        hourlyRate: coachData.hourlyRate,
        specialties: JSON.stringify(coachData.specialties),
        approved: true,
        rating: coachData.rating,
        totalReviews: coachData.totalReviews,
      },
    });

    // Add availability (Mon-Sat, 9am-6pm)
    const coach = await prisma.coach.findUnique({ where: { userId: user.id } });
    for (let day = 1; day <= 6; day++) {
      await prisma.availability.create({
        data: {
          coachId: coach.id,
          dayOfWeek: day,
          startTime: '09:00',
          endTime: '18:00',
          isRecurring: true,
        },
      });
    }

    console.log(`Created coach: ${coachData.name}`);
  }

  console.log('Seeding complete!');
  console.log('\nDemo credentials:');
  console.log('Admin:   admin@tennismarket.com / admin123');
  console.log('Student: student@demo.com / student123');
  console.log('Coach:   rafael@tenniscoach.com / coach123');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
