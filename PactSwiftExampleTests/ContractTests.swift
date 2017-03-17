import Quick
import Nimble
import PactSwiftExample
import PactConsumerSwift

class ContractTests: QuickSpec {
    var seedProvider: MockService?
    var seedClient: SeedClient?
    var helloClient: HelloClient?

    override func spec() {
        describe("Client Contract Tests") {

            beforeEach {
                self.seedProvider = MockService(provider: "Seed Provider", consumer: "Seed Consumer")
                self.seedClient = SeedClient(baseUrl: self.seedProvider!.baseUrl)
                self.helloClient = HelloClient(baseUrl: self.seedProvider!.baseUrl)
            }

            it ("conforms to contract for seeds") {
                self.seedProvider!
                    .uponReceiving("a request for seeds")
                    .withRequest(method:.GET, path: "/seeds")
                    .willRespondWith(status: 200, headers: ["Content-Type": "application/json"],
                                     body: ["seeds": "some seeds"]
                    )

                self.seedProvider!.run {
                    (testComplete) -> Void in
                    self.seedClient!.getSeeds { (response) in
                        expect(response).to(equal("some seeds"))
                        testComplete()
                    }
                }
            }

            it ("says hello") {
                self.seedProvider!
                    .uponReceiving("a request for hello")
                    .withRequest(method:.GET, path: "/sayHello")
                    .willRespondWith(status: 200, headers: ["Content-Type": "application/json"],
                                     body: ["reply": "Hello"]
                )

                self.seedProvider!.run {
                    (testComplete) -> Void in
                    self.helloClient!.sayHello { (response) in
                        expect(response).to(equal("Hello"))
                        testComplete()
                    }
                }
            }
        }
    }
}
