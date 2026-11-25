package com.fliq.fliq.signup;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class SignupDTO {
    private long u_id;
    private String u_email;
    private String u_password;
    private String u_nickname;
}
