module ALU(A, B, Result, ALUControl, OverFlow, Carry, Zero, Negative);

    input [31:0] A, B;
    input [2:0] ALUControl;
    output Carry, OverFlow, Zero, Negative;
    output [31:0] Result;

    reg [31:0] Result;
    reg OverFlow, Carry, Zero, Negative;
    wire [31:0] Sum;
    wire Cout;

    assign {Cout, Sum} = (ALUControl[0] == 1'b0) ? A + B : A + (~B + 1);

    always @(*) begin
        case(ALUControl)
            3'b000: begin // ADD
                Result = Sum;
            end
            3'b001: begin // SUB
                Result = Sum;
            end
            3'b010: begin // AND
                Result = A & B;
            end
            3'b011: begin // OR
                Result = A | B;
            end
            3'b101: begin // SLT (set less than)
                Result = {31'b0, Sum[31]};
            end
            default: begin
                Result = 32'b0;
            end
        endcase

        OverFlow = (ALUControl == 3'b000 || ALUControl == 3'b001) && 
                   ((Sum[31] ^ A[31]) & ~(ALUControl[0] ^ B[31] ^ A[31]));

        Carry = (ALUControl == 3'b000 || ALUControl == 3'b001) && Cout;

        Zero = (Result == 32'b0);
        
        Negative = Result[31];
    end

endmodule