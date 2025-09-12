package br.com.ifs.musicshow.models;

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
@Table(name = "tb_banda_musica")
public class BandaMusicaModel implements Serializable {

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
    @JoinColumn(name = "id_musica", nullable = false)
    private MusicaModel musica;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "id_repertorio", nullable = false)
    private RepertorioModel repertorio;

    @Column(name = "data_inclusao", nullable = false)
    private Date dataInclusao;

    @Column(name = "ordem", nullable = false)
    private int ordem;

}
