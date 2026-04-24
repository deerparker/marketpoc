import '../banking_provider.dart';

abstract class BankService {
  Future<Account> getAccount(String userId);
  Future<List<Account>> getAccounts(String userId);
  Future<List<Transaction>> getTransactions(String userId);
}

class StubBankService implements BankService {
  @override
  Future<Account> getAccount(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final accounts = await getAccounts(userId);
    return accounts.first; // Return primary account
  }

  @override
  Future<List<Account>> getAccounts(String userId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Return different accounts based on user persona/ID
    // You can customize this based on actual user data
    if (userId.contains('check')) {
      // "Budget Conscious" persona
      return [
        Account(
          id: '1',
          name: 'Basic Checking',
          balance: 1450.25,
          accountNumber: '**** 4512',
          type: 'checking',
        ),
        Account(
          id: '2',
          name: 'Emergency Savings',
          balance: 5800.00,
          accountNumber: '**** 8921',
          type: 'savings',
        ),
      ];
    } else if (userId.contains('grow')) {
      // "Growing Family" persona
      return [
        Account(
          id: '1',
          name: 'Joint Checking',
          balance: 8920.50,
          accountNumber: '**** 3467',
          type: 'checking',
        ),
        Account(
          id: '2',
          name: 'Family Savings',
          balance: 28500.00,
          accountNumber: '**** 7821',
          type: 'savings',
        ),
        Account(
          id: '3',
          name: 'Rewards Credit Card',
          balance: -842.30,
          accountNumber: '**** 9912',
          type: 'credit',
        ),
      ];
    } else {
      // Default/high earner
      return [
        Account(
          id: '1',
          name: 'Premium Checking',
          balance: 45280.75,
          accountNumber: '**** 1234',
          type: 'checking',
        ),
        Account(
          id: '2',
          name: 'Investment Savings',
          balance: 125000.00,
          accountNumber: '**** 5678',
          type: 'savings',
        ),
        Account(
          id: '3',
          name: 'Platinum Credit Card',
          balance: -3240.80,
          accountNumber: '**** 9101',
          type: 'credit',
        ),
      ];
    }
  }

  @override
  Future<List<Transaction>> getTransactions(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Transaction(
        id: '1',
        title: 'Apple Store',
        subtitle: 'Electronics',
        amount: 99.99,
        date: DateTime.now().subtract(const Duration(hours: 2)),
        isDebit: true,
      ),
      Transaction(
        id: '2',
        title: 'Salary Deposit',
        subtitle: 'Employer Inc.',
        amount: 4500.00,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isDebit: false,
      ),
      Transaction(
        id: '3',
        title: 'Starbucks',
        subtitle: 'Coffee',
        amount: 5.45,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isDebit: true,
      ),
      Transaction(
        id: '4',
        title: 'Netflix',
        subtitle: 'Subscription',
        amount: 15.99,
        date: DateTime.now().subtract(const Duration(days: 3)),
        isDebit: true,
      ),
      Transaction(
        id: '5',
        title: 'Uber',
        subtitle: 'Transport',
        amount: 24.50,
        date: DateTime.now().subtract(const Duration(days: 4)),
        isDebit: true,
      ),
    ];
  }
}

class RemoteBankService implements BankService {
  @override
  Future<Account> getAccount(String userId) async {
    // TODO: Implement API call with userId
    throw UnimplementedError();
  }

  @override
  Future<List<Account>> getAccounts(String userId) async {
    // TODO: Implement API call with userId
    throw UnimplementedError();
  }

  @override
  Future<List<Transaction>> getTransactions(String userId) async {
    // TODO: Implement API call with userId
    throw UnimplementedError();
  }
}
