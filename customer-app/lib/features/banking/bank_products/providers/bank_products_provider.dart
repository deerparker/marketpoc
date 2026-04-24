import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bank_product.dart';

final bankProductsProvider = Provider<List<BankProduct>>((ref) {
  return [
    // --- Loans ---
    const BankProduct(
      id: 'personal_loan',
      title: 'Personal Loan',
      description: 'Get a loan for your personal needs with competitive rates.',
      type: 'loan',
      imageUrl:
          'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?auto=format&fit=crop&q=80&w=100',
      interestRate: 5.5,
      minAmount: 1000,
      maxAmount: 50000,
    ),
    const BankProduct(
      id: 'car_loan',
      title: 'Car Loan',
      description: 'Drive away your dream car with our low-rate auto loans.',
      type: 'loan',
      imageUrl:
          'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?auto=format&fit=crop&q=80&w=100',
      interestRate: 4.9,
      minAmount: 5000,
      maxAmount: 100000,
    ),
    const BankProduct(
      id: 'business_loan',
      title: 'Business Startup Loan',
      description: 'Fuel your new venture with flexible financing.',
      type: 'loan',
      imageUrl:
          'https://images.unsplash.com/photo-1450101499163-c8848c66ca85?auto=format&fit=crop&q=80&w=100',
      interestRate: 6.5,
      minAmount: 10000,
      maxAmount: 250000,
    ),
    const BankProduct(
      id: 'student_loan',
      title: 'Student Loan',
      description: 'Support your education with our student-friendly loans.',
      type: 'loan',
      imageUrl:
          'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&q=80&w=100',
      interestRate: 3.5,
      minAmount: 2000,
      maxAmount: 20000,
    ),

    // --- Mortgages ---
    const BankProduct(
      id: 'mortgage_standard',
      title: 'Standard Mortgage',
      description: 'Fixed rate mortgage for your dream home.',
      type: 'mortgage',
      imageUrl:
          'https://images.unsplash.com/photo-1560518883-ce09059eeffa?auto=format&fit=crop&q=80&w=100',
      interestRate: 4.5,
      minAmount: 100000,
      maxAmount: 1000000,
    ),

    // --- Credit Cards ---
    const BankProduct(
      id: 'credit_card_gold',
      title: 'Gold Credit Card',
      description: 'Premium benefits and travel insurance included.',
      type: 'credit_card',
      imageUrl:
          'https://images.unsplash.com/photo-1556742049-0cfed4f7a07d?auto=format&fit=crop&q=80&w=100',
      interestRate: 18.9,
    ),
    const BankProduct(
      id: 'credit_card_student',
      title: 'Student Credit Card',
      description: 'Build your credit while you study.',
      type: 'credit_card',
      imageUrl:
          'https://images.unsplash.com/photo-1563013544-824ae1b704d3?auto=format&fit=crop&q=80&w=100',
      interestRate: 12.9,
      maxAmount: 1500,
    ),

    // --- Savings & Accounts ---
    const BankProduct(
      id: 'savings_plus',
      title: 'Savings Plus',
      description: 'High-yield savings account for your future goals.',
      type: 'savings',
      imageUrl:
          'https://images.unsplash.com/photo-1601597111158-2fceff292cdc?auto=format&fit=crop&q=80&w=100',
      interestRate: 3.2,
    ),
    const BankProduct(
      id: 'junior_isa',
      title: 'Junior ISA',
      description: 'Tax-free savings for your child\'s future.',
      type: 'savings',
      imageUrl:
          'https://images.unsplash.com/photo-1519689680058-324335c77eba?auto=format&fit=crop&q=80&w=100',
      interestRate: 4.0,
    ),
    const BankProduct(
      id: 'business_account',
      title: 'Business Account',
      description: 'Manage your business finances with ease.',
      type: 'savings', // Using 'savings' loosely as 'account' for now
      imageUrl:
          'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=100',
    ),
    const BankProduct(
      id: 'student_account',
      title: 'Student Account',
      description: 'Fee-free banking for university students.',
      type: 'savings',
      imageUrl:
          'https://images.unsplash.com/photo-1523240795612-9a054b0db644?auto=format&fit=crop&q=80&w=100',
    ),

    // --- Partner Products (Insurance) ---
    const BankProduct(
      id: 'car_insurance_compare',
      title: 'Car Insurance Comparison',
      description: 'Find the best deal for your car insurance.',
      type: 'insurance',
      imageUrl:
          'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?auto=format&fit=crop&q=80&w=100',
      partnerName: 'CompareTheRates',
      isPartner: true,
    ),
    const BankProduct(
      id: 'home_insurance_safe',
      title: 'Home Insurance',
      description: 'Protect your home with comprehensive coverage.',
      type: 'insurance',
      imageUrl:
          'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f8e?auto=format&fit=crop&q=80&w=100',
      partnerName: 'SafeHome',
      isPartner: true,
    ),
    const BankProduct(
      id: 'life_insurance_family',
      title: 'Family Life Insurance',
      description: 'Secure your family\'s financial future.',
      type: 'insurance',
      imageUrl:
          'https://images.unsplash.com/photo-1511895426328-dc8714191300?auto=format&fit=crop&q=80&w=100',
      partnerName: 'LifeSecure',
      isPartner: true,
    ),
    const BankProduct(
      id: 'health_insurance_vital',
      title: 'Health Insurance',
      description: 'Comprehensive health cover including gym discounts.',
      type: 'insurance',
      imageUrl:
          'https://images.unsplash.com/photo-1576091160399-112ba8d25d1d?auto=format&fit=crop&q=80&w=100',
      partnerName: 'VitalityPlus',
      isPartner: true,
    ),
    // --- Current Accounts ---
    const BankProduct(
      id: 'premier_account',
      title: 'Premier Current Account',
      description: 'Exclusive benefits and worldwide travel insurance.',
      type: 'current_account',
      imageUrl:
          'https://images.unsplash.com/photo-1556740738-b6a63e27c4df?auto=format&fit=crop&q=80&w=100',
    ),
    const BankProduct(
      id: 'basic_account',
      title: 'Basic Current Account',
      description: 'Simple, fee-free daily banking.',
      type: 'current_account',
      imageUrl:
          'https://images.unsplash.com/photo-1620714223084-874165c5ce57?auto=format&fit=crop&q=80&w=100',
    ),
    const BankProduct(
      id: 'fixed_rate_bond',
      title: '1 Year Fixed Rate Bond',
      description: 'Guaranteed 5.0% return on your savings.',
      type: 'savings',
      imageUrl:
          'https://images.unsplash.com/photo-1565514020176-db710c563d3d?auto=format&fit=crop&q=80&w=100',
      interestRate: 5.0,
      minAmount: 500,
    ),
  ];
});
