package br.com.ifs.musicshow.models;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serial;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@Table(name = "tb_banda")
public class BandaModel implements Serializable {

    @Serial
    private static final long serialVersionUID = 1L;

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id", nullable = false)
    private Integer id;

    @ManyToOne
    @JoinColumn(name = "id_usuario", nullable = false)
    private UsuarioModel usuario;

    @Column(name = "nome", nullable = false)
    private String nome;

    @Column(name = "qtd_integrante", nullable = false)
    private int qtdIntegrante;

    @Column(name = "qtd_repertorio", nullable = false)
    private int qtdRepertorio;

    @Column(name = "data_criacao", nullable = false)
    private Date dataCriacao;

    @Column(name = "status", nullable = false)
    private int status;

    @OneToMany(mappedBy = "banda", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<UsuarioBandaModel> usuariosBanda = new ArrayList<>();

    public static final int STATUS_ATIVO = 1;
    public static final int STATUS_INATIVO = 0;

    public String status() {
        switch (status) {
            case STATUS_ATIVO: return "ATIVO";
            case STATUS_INATIVO: return "INATIVO";
            default: return "DESCONHECIDO";
        }
    }
}
