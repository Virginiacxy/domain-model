//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
	public var amount : Int
    public var currency : String
  
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: String) -> Money {
        if self.currency == "USD" {
            switch to {
                case "USD": return self
                case "GBP": return Money(amount: self.amount / 2, currency: "GBP")
                case "EUR": return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR")
                case "CAN": return Money(amount: Int(Double(self.amount) * 1.25), currency: "CAN")
                default:
                    print("Don't know the corresponding exchange rate.")
                    return self
            }
        } else if (self.currency == "GBP") {
            switch to {
                case "GBP": return self
                case "USD": return Money(amount: self.amount * 2, currency: "USD")
                default:
                    print("Don't know the corresponding exchange rate.")
                    return self
            }
        } else if (self.currency == "EUR") {
            switch to {
            case "EUR": return self
            case "USD": return Money(amount: Int(Double(self.amount) / 1.5), currency: "USD")
            default:
                print("Don't know the corresponding exchange rate.")
                return self
            }
        } else if (self.currency == "CAN") {
            switch to {
            case "CAN": return self
            case "USD": return Money(amount: Int(Double(self.amount) / 1.25), currency: "USD")
            default:
                print("Don't know the corresponding exchange rate.")
                return self
            }
        } else {
            print("Unknown currency")
            return self
        }
    }
  
    public func add(_ to: Money) -> Money {
        if self.currency == to.currency {
            return Money(amount: self.amount + to.amount, currency: to.currency)
        } else {
            return to.add(_:self.convert(to.currency))
        }
    }
    public func subtract(_ from: Money) -> Money {
        if self.currency == from.currency {
            return Money(amount: from.amount - self.amount, currency: from.currency)
        } else {
            return self.convert(from.currency).subtract(_:from)
        }
    }
}

////////////////////////////////////
// Job
//
open class Job {
  fileprivate var title : String
  fileprivate var type : JobType

  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
  
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
//    if case let .Hourly(h) = type {
//        self.type = .Hourly(h)
//    }
//    if case let .Salary(s) = type {
//        self.type = .Salary(s)
//    }
  }
  
  open func calculateIncome(_ hours: Int) -> Int {
    switch self.type {
        case .Hourly(let num): return Int(num * Double(hours))
        case .Salary(let num): return num
    }
  }
  
  open func raise(_ amt : Double) {
    switch self.type {
        case .Hourly(let num): self.type = JobType.Hourly(num + amt)
        case .Salary(let num): self.type = JobType.Salary(num + Int(amt))
    }
  }
}

////////////////////////////////////
// Person
//
open class Person {
  open var firstName : String = ""
  open var lastName : String = ""
  open var age : Int = 0

  fileprivate var _job : Job? = nil
  open var job : Job? {
    get {
        if self.age < 16 {
            return nil
        } else {
            return self._job
        }
    }
    set(value) {
        self._job = value
    }
  }
  
  fileprivate var _spouse : Person? = nil
  open var spouse : Person? {
    get {
        if self.age < 18 {
            return nil
        } else {
            return self._spouse
        }
     }
    set(value) {
        self._spouse = value
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  open func toString() -> String {
    return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(String(describing: job)) spouse:\(String(describing: spouse))]"
  }
}

////////////////////////////////////
// Family
//
open class Family {
  fileprivate var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if (spouse1._spouse == nil && spouse2._spouse == nil) {
        members.append(spouse1)
        members.append(spouse2)
        spouse1.spouse = spouse2
        spouse2.spouse = spouse1
    }
  }
  
  open func haveChild(_ child: Person) -> Bool {
    if members[0].age > 21 || members[1].age > 21 {
        members.append(child)
        return true
    } else {
        return false
    }
  }
  
  open func householdIncome() -> Int {
    var income = 0
    for person in members {
        if person.job != nil {
            income += person.job!.calculateIncome(50 * 5 * 8)
        }
    }
    return income
  }
}





