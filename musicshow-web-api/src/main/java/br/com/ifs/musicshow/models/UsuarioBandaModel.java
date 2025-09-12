package br.com.ifs.musicshow.models;

import br.com.ifs.musicshow.roles.UsuarioBandaRole;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.Date;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_usuario_banda")
public class UsuarioBandaModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_banda", nullable = false)
    private BandaModel banda;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_usuario", nullable = false)
    private UsuarioModel usuario;

    @Column(name = "data_inclusao", nullable = false)
    private Date dataInclusao;

    @Enumerated(EnumType.STRING)
    @Column(name = "papel_user", nullable = false)
    private UsuarioBandaRole papelUser;

}
